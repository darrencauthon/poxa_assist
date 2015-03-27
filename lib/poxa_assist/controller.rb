module PoxaAssist

  module Controller

    def self.included(receiver)
      receiver.instance_eval do
        begin
          protect_from_forgery :except => [:auth, :js_file]
          skip_before_filter :verify_authenticity_token
        rescue
        end
      end
    end

    def js_file
      render js: PoxaAssist.client_js
    end

    def auth
      channel = Pusher[params[:channel_name]]
      #response = channel.authenticate(params[:socket_id], {
        #:user_id => "darren",
        #:user_info => {}
      #})
      data = PoxaAssist.auth(controller: self, params: params)
      if data
        response = channel.authenticate(params[:socket_id], data)
        render :json => response
      else
        render :text => "Forbidden", :status => '403'
      end
    end

  end

end
