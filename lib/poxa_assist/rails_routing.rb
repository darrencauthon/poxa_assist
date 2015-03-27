module PoxaAssist
  module RailsRouting
    def self.inject_into routes
      routes.send(:get, '/js/pusher.min.js' => 'poxa#js_file')
      routes.send(:post, '/pusher/auth'     => 'poxa#auth')
    end
  end
end
