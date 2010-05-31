%w(rubygems pp ap wirble bond date time).each do |lib|
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

Bond.start

IRB::Irb.class_eval do
  def output_value
    ap @context.last_value
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
