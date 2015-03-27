module PoxaAssist

  class Config

    attr_accessor :host, :port, :ssl_port, :app_id, :app_key, :app_secret, :encrypted

    def self.build_from options
      val = {
              host:       (options[:host]       || ENV['POXA_HOST']),
              port:       (options[:port]       || ENV['POXA_PORT']).to_i,
              ssl_port:   (options[:ssl_port]   || ENV['POXA_SSL_PORT']).to_i,
              app_id:     (options[:app_id]     || ENV['POXA_APP_ID']),
              app_key:    (options[:app_key]    || ENV['POXA_APP_KEY']),
              app_secret: (options[:app_secret] || ENV['POXA_APP_SECRET']),
            }
      val[:encrypted] = val[:ssl_port] != 0

      self.new.tap do |c|
        val.each { |k, v| c.send "#{k}=".to_sym, v }
      end

    end

  end

end
