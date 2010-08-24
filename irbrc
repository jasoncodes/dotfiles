%w(rubygems wirble bond).each do |lib|
  begin
    require lib
  rescue LoadError => err
    warn "Warning: Couldn't load #{lib}: #{err}"
  end
end


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
  $on_irb_init.each &:call
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


if Readline::VERSION =~ /editline/i
  warn "Warning: Using Editline instead of Readline."
end

module Readline
  
  module History
    HISTORY_FILE = "#{ENV['HOME']}/.irb_history"
    
    def self.load_history
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
  
  def readline_with_log(*args)
    line = readline_without_log(*args)
    History.write_log line
    line
  end
  alias_method :readline_without_log, :readline
  alias_method :readline, :readline_with_log
  
end
Readline::History.load_history


IRB.conf[:PROMPT][:SHORT] = {
  :PROMPT_C=>"%03n:%i* ",
  :RETURN=>"%s\n",
  :PROMPT_I=>"%03n:%i> ",
  :PROMPT_N=>"%03n:%i> ",
  :PROMPT_S=>"%03n:%i%l "
}
IRB.conf[:PROMPT_MODE] = :SHORT

# blue is hard to see on black, so replace all blues with purple
Wirble::Colorize::Color::COLORS.merge!({
  :blue => '0;35'
})

Wirble.init(:skip_prompt => true, :skip_history => true, :init_colors => true)

Kernel.at_exit do
  puts
end

Bond.start


# awesome_print is awesome
on_irb_init do
  extend_console 'ap' do
    IRB::Irb.class_eval do
      def output_value
        value = @context.last_value
        value = value.proxy_target if value.respond_to? :proxy_target
        ap value
      end
    end
  end
end


# methods that are defined directly on this object's class
class Object
  def local_methods
    (methods - self.class.superclass.instance_methods).sort
  end
end


# This is only done when using the Rails console
if rails_env = ENV['RAILS_ENV']
  
  # This is only done when the irb session rails are fully loaded
  IRB.conf[:IRB_RC] = Proc.new do
    # Log ActiveRecord calls to standard out
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
  
  # supress the ActiveRecord debug output when autocompleting
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
