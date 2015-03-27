module PoxaAssist

  class Channel

    def initialize pusher_channel
      @channel = pusher_channel
    end

    def trigger name, data = {}
      @channel.trigger name.to_s, data
    end

  end

end
