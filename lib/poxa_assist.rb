require 'pusher'
require "poxa_assist/version"
Dir[File.dirname(__FILE__) + '/poxa_assist/*.rb'].each { |f| require f }

module PoxaAssist

  def self.client_js options = {}
    PUSHER_JAVASCRIPT_FILE.gsub('{{HOST}}',    (options[:host]    || config.host).to_s)
                          .gsub('{{PORT}}',    (options[:port]    || config.port).to_s)
                          .gsub('{{APP_KEY}}', (options[:app_key] || config.app_key).to_s)
                          .gsub('{{ENCRYPTED}}', (options[:encrypted] || config.encrypted).to_s)
                          .gsub('{{SSL_PORT}}', (options[:ssl_port] || config.ssl_port).to_s)
  end

  def self.start options = {}
    @options = options
    set_the_pusher_values
  end

  def self.channel_for name
    PoxaAssist::Channel.new Pusher[name.to_s]
  end

  def self.set_the_pusher_values
    Pusher.port = if PoxaAssist.config.ssl_port && PoxaAssist.config.ssl_port > 0
                    Pusher.encrypted = true
                    PoxaAssist.config.ssl_port
                  else
                    PoxaAssist.config.port
                  end
    fields = { 
               host:    :host,
               key:     :app_key,
               app_id:  :app_id,
               secret:  :app_secret,
             }
    fields.each do |k, v|
      Pusher.send("#{k}=".to_sym, PoxaAssist.config.send(v))
    end
  end

  def self.config
    @options ||= {}
    Struct.new(:host, :port, :ssl_port, :app_id, :app_key, :app_secret, :encrypted)
          .new(@options[:host]       || ENV['POXA_HOST'],
               (@options[:port]      || ENV['POXA_PORT']).to_s.to_i,
               (@options[:ssl_port]  || ENV['POXA_SSL_PORT']).to_s.to_i,
               @options[:app_id]     || ENV['POXA_APP_ID'],
               @options[:app_key]    || ENV['POXA_APP_KEY'],
               @options[:app_secret] || ENV['POXA_APP_SECRET'],
               (@options[:ssl_port]  || ENV['POXA_SSL_PORT']).to_s.to_i != 0)
  end

  # you will want to replace this yourself
  def self.auth options
    nil
      #{
        #:user_id => "darren",
        #:user_info => {}
      #})
  end

end
