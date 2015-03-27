require_relative 'spec_helper'

describe PoxaAssist do

  describe "setting the application details" do

    describe "default environment variables" do

      [
        [:host,       'POXA_HOST',       :host=,   Object.new, nil],
        [:port,       'POXA_PORT',       :port=,   '1234',     1234],
        [:port,       'POXA_PORT',       :port=,   1234,       1234],
        [:app_key,    'POXA_APP_KEY',    :key=,    Object.new, nil],
        [:app_id,     'POXA_APP_ID',     :app_id=, Object.new, nil],
        [:app_secret, 'POXA_APP_SECRET', :secret=, Object.new, nil],
      ].map { |x| Struct.new(:key, :env_key, :pusher_key, :input, :output).new(*x) }.each do |example|

        describe "#{example.key} defaults to #{example.env_key}" do

          before { example.output ||= example.input }

          it "should set the pusher key (#{example.pusher_key}) as expected" do

            value = example.input
            ENV.stubs(:[]).returns nil
            ENV.stubs(:[]).with(example.env_key).returns value
            Pusher.expects(example.pusher_key).with example.output
            PoxaAssist.start

          end

          it "should look in the environment variables if none exist" do

            ENV.stubs(:[]).returns nil
            PoxaAssist.start
            value = example.input
            ENV.expects(:[]).with(example.env_key).returns value
            PoxaAssist.config.send(example.key).must_equal example.output

          end

          it "should look in the environment variables if start was never called" do

            PoxaAssist.instance_eval { @options = nil }

            ENV.stubs(:[]).returns nil
            value = example.input
            ENV.expects(:[]).with(example.env_key).returns value
            PoxaAssist.config.send(example.key).must_equal example.output

          end

        end

      end

    end

  end

  describe "start" do
    
    before do
      Pusher.stubs(:host=)
      Pusher.stubs(:port=)
      Pusher.stubs(:key=)
      Pusher.stubs(:app_id=)
      Pusher.stubs(:secret=)
    end

    it "should set the host on pusher" do

      options = {
                  host: Object.new,
                }

      Pusher.expects(:host=).with options[:host]

      PoxaAssist.start options
        
    end

    it "should set the port on pusher" do

      options = {
                  port: '1234'
                }

      Pusher.expects(:port=).with 1234

      PoxaAssist.start options
        
    end

    it "should set the key on pusher" do

      options = {
                  app_key: Object.new
                }

      Pusher.expects(:key=).with options[:app_key]

      PoxaAssist.start options
        
    end

    it "should set the app_id on pusher" do

      options = {
                  app_id: Object.new
                }

      Pusher.expects(:app_id=).with options[:app_id]

      PoxaAssist.start options
        
    end

    it "should set the secret on pusher" do

      options = {
                  app_secret: Object.new
                }

      Pusher.expects(:secret=).with options[:app_secret]

      PoxaAssist.start options
        
    end

    describe "just a ssl port was given" do
      it "should not set the encrypted flag" do
        options = {
                    port: Object.new
                  }

        Pusher.expects(:encrypted=).never

        PoxaAssist.start options
      end
    end

    describe "a ssl port was given" do

      let(:ssl_port) { 8443 }

      it "should set the port on pusher" do
        options = {
                    ssl_port: ssl_port
                  }

        Pusher.expects(:port=).with options[:ssl_port]

        PoxaAssist.start options
      end

      it "should set encrypted to true" do
        options = {
                    ssl_port: ssl_port
                  }

        Pusher.expects(:encrypted=).with true

        PoxaAssist.start options
          
      end

      describe "and a regular port was provided" do
        it "should set the SSL port" do
          options = {
                      ssl_port: ssl_port,
                      port:     443 
                    }

          Pusher.expects(:port=).with ssl_port

          PoxaAssist.start options
        end
      end
    end

    it "should set the host in config" do
      options = { host: Object.new }
      PoxaAssist.start options
      PoxaAssist.config.host.must_be_same_as options[:host]
    end

    it "should set the port in config" do
      options = { port: '1234' }
      PoxaAssist.start options
      PoxaAssist.config.port.must_be_same_as 1234
    end

    it "should set the app_id in config" do
      options = { app_id: Object.new }
      PoxaAssist.start options
      PoxaAssist.config.app_id.must_be_same_as options[:app_id]
    end

    it "should set the app_key in config" do
      options = { app_key: Object.new }
      PoxaAssist.start options
      PoxaAssist.config.app_key.must_be_same_as options[:app_key]
    end

    it "should set the app_secret in config" do
      options = { app_secret: Object.new }
      PoxaAssist.start options
      PoxaAssist.config.app_secret.must_be_same_as options[:app_secret]
    end

  end

  describe "the default auth" do
    it "should return nothing" do
      PoxaAssist.auth(nil).nil?.must_equal true
    end
  end

  describe "channel_for" do

    ['test', 'test2'].each do |name|

      describe "multiple examples" do

        let(:expected)       { Object.new }
        let(:pusher_channel) { Object.new }

        before do
          Pusher.stubs(:[]).with(name).returns pusher_channel
          Pusher.stubs(:url=)
          PoxaAssist::Channel.stubs(:new).with(pusher_channel).returns expected
        end

        it "should return poxa assist channels" do
          PoxaAssist.channel_for(name).must_be_same_as expected
        end

        it "should work with symbols as well" do
          PoxaAssist.channel_for(name.to_sym).must_be_same_as expected
        end

      end

    end

  end

end
