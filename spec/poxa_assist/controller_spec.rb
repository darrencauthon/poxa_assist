require_relative '../spec_helper'

class TestController
  include PoxaAssist::Controller
end

describe PoxaAssist::Controller do

  let(:params) { {} }

  let(:controller) do
    c = TestController.new
    c.stubs(:params).returns params
    c
  end

  describe "the client js file" do
    it "should render the proper js" do
      js = Object.new
      PoxaAssist.stubs(:client_js).returns js
      controller.expects(:render).with(js: js)
      controller.js_file
    end
  end

  describe "auth" do

    describe "when the custom auth method provided data" do

      it "should call the auth method" do

        channel_name, socket_id = Object.new, Object.new
        params[:channel_name]   = channel_name
        params[:socket_id]      = socket_id

        channel  = Object.new
        data     = Object.new
        response = Object.new

        Pusher.stubs(:[]).with(channel_name)
                         .returns channel

        channel.stubs(:authenticate)
               .with(socket_id, data)
               .returns response

        PoxaAssist.expects(:auth)
                  .with(controller: controller,
                        params:     params)
                  .returns data

        controller.expects(:render).with(json: response)

        controller.auth

      end

    end

    describe "when the custom auth method returns nil" do

      it "should call the auth method" do

        channel_name, socket_id = Object.new, Object.new
        params[:channel_name]   = channel_name
        params[:socket_id]      = socket_id

        channel  = Object.new
        data     = Object.new
        response = Object.new

        Pusher.stubs(:[]).with(channel_name)
                         .returns channel

        channel.stubs(:authenticate)
               .with(socket_id, data)
               .returns response

        PoxaAssist.expects(:auth)
                  .with(controller: controller,
                        params:     params)
                  .returns nil

        controller.expects(:render)
                  .with(text: 'Forbidden', status: '403')

        controller.auth

      end

    end

  end

end
