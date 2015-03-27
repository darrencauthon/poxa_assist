require 'hmac-sha2'
require 'open-uri'
require 'json'

module PoxaAssist

  module RestApi

    def self.users_on channel
      url = generate_users_url(channel)
      JSON.parse(open(url).read)['users'].map { |x| x['id'] }
    rescue
      []
    end

    def self.generate_users_url channel, options = nil

      options = pull_options_from_config_if_necessary options

      url            = "/apps/#{options[:app_id]}/channels/#{channel}/users"
      arguments      = "auth_key=#{options[:app_key]}&auth_timestamp=#{Time.now.to_i}&auth_version=1.0"
      auth_signature = generate_the_auth_signature_from url, arguments, options
      port           = options[:ssl_port].to_i > 0 ? options[:ssl_port] : options[:port]
      protocol       = options[:ssl_port].to_i > 0 ? "https" : "http"

      "#{protocol}://#{options[:host]}:#{port}#{url}?#{arguments}&auth_signature=#{auth_signature}"
    end

    class << self

      private

      def generate_the_auth_signature_from url, arguments, options
        string_to_sign = "GET\n#{url}\n#{arguments}"
        auth_signature = HMAC::SHA256.hexdigest(options[:app_secret], string_to_sign)
      end

      def pull_options_from_config_if_necessary options
        return options if options
        {
          host:       PoxaAssist.config.host,
          ssl_port:   PoxaAssist.config.ssl_port,
          port:       PoxaAssist.config.port,
          app_id:     PoxaAssist.config.app_id,
          app_key:    PoxaAssist.config.app_key,
          app_secret: PoxaAssist.config.app_secret
        }
      end

    end

  end

end
