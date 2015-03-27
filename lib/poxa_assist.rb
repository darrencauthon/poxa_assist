require 'pusher'
require "poxa_assist/version"
Dir[File.dirname(__FILE__) + '/poxa_assist/*.rb'].each { |f| require f }

module PoxaAssist

  def self.client_js options = {}
    values_to_replace_considering(options)
      .reduce(pusher_javascript_file) { |f, v| f.gsub v[0], v[1].to_s }
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
    val = {
            host:       (@options[:host]       || ENV['POXA_HOST']),
            port:       (@options[:port]       || ENV['POXA_PORT']).to_i,
            ssl_port:   (@options[:ssl_port]   || ENV['POXA_SSL_PORT']).to_i,
            app_id:     (@options[:app_id]     || ENV['POXA_APP_ID']),
            app_key:    (@options[:app_key]    || ENV['POXA_APP_KEY']),
            app_secret: (@options[:app_secret] || ENV['POXA_APP_SECRET']),
          }
    val[:encrypted] = val[:ssl_port] != 0

    Struct.new(:host,      :port,      :ssl_port,      :app_id,      :app_key,      :app_secret,      :encrypted)
          .new(val[:host], val[:port], val[:ssl_port], val[:app_id], val[:app_key], val[:app_secret], val[:encrypted])
  end

  # you will want to replace this yourself
  def self.auth options
    nil
      #{
        #:user_id => "darren",
        #:user_info => {}
      #})
  end

  class << self

    private

    def values_to_replace_considering options
      [:host, :port, :app_key, :encrypted, :ssl_port].reduce({}) do |hash, field|
        key   = "{{#{field.to_s.upcase}}}"
        value = options[field] || config.send(field)
        hash.merge key => value
      end
    end

  end


end
