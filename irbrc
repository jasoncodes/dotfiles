%w(rubygems pp ap wirble hirb date time).each do |lib|
  begin
    require lib
  rescue LoadError => err
    warn "Warning: Couldn't load #{lib}: #{err}"
  end
end

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


extend Hirb::Console
Hirb.enable :pager=>false


# BEGIN http://rhnh.net/2009/12/29/ruby-debugging-with-puts-tap-and-hirb

class Object
  def tapp(prefix = nil, &block)
    block ||= lambda {|x| x }
    
    tap do |x|
      value = block[x]
      value = Hirb::View.formatter.format_output(value) || value.inspect
      
      if prefix
        print prefix
        if value.lines.count > 1
          print ":\n"
        else
          print ": "
        end
      end
      puts value
    end
  end
end

# END http://rhnh.net/2009/12/29/ruby-debugging-with-puts-tap-and-hirb


# This is only done when using the Rails console
if rails_env = ENV['RAILS_ENV']
  # This is only done when the irb session rails are fully loaded
  IRB.conf[:IRB_RC] = Proc.new do
    # Log ActiveRecord calls to standard out
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end


# always render single records in vertical mode. This is handy for inspecting objects attributes.
if defined? Hirb
  class Hirb::Helpers::Table
    class <<self
      def render_with_vertical_singular(rows, options={})
        if !rows.is_a?(Array) or rows.size == 1
          options[:vertical] = true
        end
        render_without_vertical_singular(rows, options)
      end
      alias_method :render_without_vertical_singular, :render
      alias_method :render, :render_with_vertical_singular
    end
  end
end
