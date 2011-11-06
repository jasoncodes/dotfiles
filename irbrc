require 'rubygems'


# ANSI colour constants
ANSI = {}
ANSI[:RESET]     = "\e[0m"
ANSI[:BOLD]      = "\e[1m"
ANSI[:UNDERLINE] = "\e[4m"
ANSI[:LGRAY]     = "\e[0;37m"
ANSI[:GRAY]      = "\e[1;30m"
ANSI[:RED]       = "\e[31m"
ANSI[:GREEN]     = "\e[32m"
ANSI[:YELLOW]    = "\e[33m"
ANSI[:BLUE]      = "\e[34m"
ANSI[:MAGENTA]   = "\e[35m"
ANSI[:CYAN]      = "\e[36m"
ANSI[:WHITE]     = "\e[37m"
# wrap ANSI escape sequences in Readline ignore markers
ANSI.each do |k,v|
  v.replace "\001#{v}\002"
end


# utility method for running code after IRB loads
$on_irb_init = []
def on_irb_init(&proc)
  $on_irb_init << proc
end
IRB.conf[:IRB_RC] = Proc.new do
  $on_irb_init.each(&:call)
end


# utility method for rescuing external dependency errors
def extend_console(name, options = {})
  options = {:require => true}.merge(options)
  if options.include? :if
    if options[:if].is_a? Proc
      return unless options[:if].call
    else
      return unless options[:if]
    end
  end
  require name if options[:require]
  yield if block_given?
rescue LoadError
  warn "#{ANSI[:RED]}Warning: could not load #{name}#{ANSI[:RESET]}"
end


# require some core stuff which I use a bit
require 'pp'
require 'date'
require 'time'


# Build a simple colourful IRB prompt
IRB.conf[:PROMPT][:SIMPLE_COLOR] = {
  :PROMPT_I => "#{ANSI[:BLUE]}>>#{ANSI[:RESET]} ",
  :PROMPT_N => "#{ANSI[:BLUE]}>>#{ANSI[:RESET]} ",
  :PROMPT_C => "#{ANSI[:RED]}?>#{ANSI[:RESET]} ",
  :PROMPT_S => "#{ANSI[:YELLOW]}?>#{ANSI[:RESET]} ",
  :RETURN   => "#{ANSI[:GREEN]}=>#{ANSI[:RESET]} %s\n",
  :AUTO_INDENT => true }
IRB.conf[:PROMPT_MODE] = :SIMPLE_COLOR

# ensure terminal is reset at exit
Kernel.at_exit do
  puts "#{ANSI[:RESET]}"
end


extend_console 'readline' do

  if Readline::VERSION =~ /editline/i
    warn "Warning: Using Editline instead of Readline."
  end

  module Readline

    module History
      HISTORY_FILE = "#{ENV['HOME']}/.irb_history"

      def self.load_history
        return unless File.exists? HISTORY_FILE
        File.open HISTORY_FILE, 'r' do |file|
          file.each do |line|
            line.strip!
            unless line.empty? or line.start_with?("#")
              if Readline::HISTORY.empty? or line != Readline::HISTORY[-1]
                HISTORY << line
              end
            end
          end
        end
      end

      def self.write_log(line)
        return if line.nil?
        line = line.strip
        return if line.empty?
        File.open HISTORY_FILE, 'ab' do |file|
          file << "#{line}\n"
        end
      end

    end

    if Readline.respond_to? :set_screen_size
      old_winch = trap 'WINCH' do
        if `stty size` =~ /\A(\d+) (\d+)\n\z/
          Readline.set_screen_size $1.to_i, $2.to_i
        end
        old_winch.call unless old_winch.nil?
      end
    end

  end

  class IRB::ReadlineInputMethod
    def gets
      if Readline.respond_to?(:input=) && @stdin
        Readline.input = @stdin
        Readline.output = @stdout
      end
      if l = readline(@prompt, false)
        if !l.empty? && (HISTORY.empty? || l != HISTORY[-1])
          HISTORY.push(l) if !l.empty?
          History.write_log l
        end
        @line[@line_no += 1] = l + "\n"
      else
        @eof = true
        l
      end
    end
  end

  Readline::History.load_history

end


extend_console 'wirble' do

  # blue is hard to see on black, so replace all blues with purple
  Wirble::Colorize::Color::COLORS.merge!({
    :blue => '0;35'
  })

  Wirble.init(:skip_prompt => true, :skip_history => true, :init_colors => true)

end


extend_console 'bond' do
  Bond.start
end


# awesome_print is awesome
on_irb_init do
  extend_console 'ap' do
    IRB::Irb.class_eval do
      def output_value
        value = @context.last_value
        case
        when value.respond_to?(:proxy_scope)
          value = value.to_a
        when value.respond_to?(:proxy_target)
          value.reload unless value.loaded?
          value = value.proxy_target
        end
        ap value
      end
    end
  end
end


# Show ActiveRecord queries in the console
extend_console 'rails', :require => false, :if => lambda { defined?(Rails) || ENV['RAILS_ENV'] } do

  on_irb_init do
    if defined? Rails
      Rails.logger = Logger.new(STDOUT) if Rails.respond_to? :logger=
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveSupport::Cache::Store.logger = Logger.new(STDOUT)
    end
  end

  # supress the ActiveRecord debug output when autocompleting
  if defined? Bond
    class Bond::Agent
      def call_with_log_supression(obj)
        org_level = ActiveRecord::Base.logger.level
        begin
          ActiveRecord::Base.logger.level = Logger::INFO if org_level < Logger::INFO
          return call_without_log_supression(obj)
        ensure
          ActiveRecord::Base.logger.level = org_level
        end
      end
      alias_method :call_without_log_supression, :call
      alias_method :call, :call_with_log_supression
    end
  end

end


# Helper to show methods that are defined directly on an object
class Object
  def local_methods
    (methods - self.class.superclass.instance_methods).sort
  end
end


# Add a method pm that shows every method on an object
# Pass a regex to filter these
extend_console 'pm', :require => false do
  def pm(obj, *options) # Print methods
    methods = obj.methods
    methods -= Object.methods unless options.include? :more
    filter  = options.select {|opt| opt.kind_of? Regexp}.first
    methods = methods.select {|name| name =~ filter} if filter

    data = methods.sort.collect do |name|
      method = obj.method(name)
      if method.arity == 0
        args = "()"
      elsif method.arity > 0
        n = method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")})"
      elsif method.arity < 0
        n = -method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")}, ...)"
      end
      klass = $1 if method.inspect =~ /Method: (.*?)#/
      [name.to_s, args, klass]
    end
    max_name = data.collect {|item| item[0].size}.max
    max_args = data.collect {|item| item[1].size}.max
    data.each do |item|
      print " #{ANSI[:YELLOW]}#{item[0].to_s.rjust(max_name)}#{ANSI[:RESET]}"
      print "#{ANSI[:BLUE]}#{item[1].ljust(max_args)}#{ANSI[:RESET]}"
      print "   #{ANSI[:GRAY]}#{item[2]}#{ANSI[:RESET]}\n"
    end
    data.size
  end
end
