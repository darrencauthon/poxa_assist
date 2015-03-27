require 'pusher'
require "poxa_assist/version"
Dir[File.dirname(__FILE__) + '/poxa_assist/*.rb'].each { |f| require f }

module PoxaAssist

  def self.client_js options = {}
    fields_to_replace = [:host, :port, :app_key, :encrypted, :ssl_port]
    fields_to_replace.reduce(pusher_javascript_file) do |file, field|
      value = options[field] || config.send(field)
      file.gsub "{{#{field.to_s.upcase}}}", value.to_s
    end
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
          .new((@options[:host]       || ENV['POXA_HOST']),
               (@options[:port]       || ENV['POXA_PORT']).to_i,
               (@options[:ssl_port]   || ENV['POXA_SSL_PORT']).to_i,
               (@options[:app_id]     || ENV['POXA_APP_ID']),
               (@options[:app_key]    || ENV['POXA_APP_KEY']),
               (@options[:app_secret] || ENV['POXA_APP_SECRET']),
               (@options[:ssl_port]   || ENV['POXA_SSL_PORT']).to_i != 0)
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
