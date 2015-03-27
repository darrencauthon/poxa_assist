require_relative '../spec_helper'

describe PoxaAssist::RestApi do

  describe "getting a list of users on a presence channel" do

    [
      ["{\"users\":[{\"id\":\"5\"},{\"id\":\"1\"}]}", ['5', '1']],
      ["{\"users\":[{\"id\":\"4\"}]}", ['4']],
      ["", []],
      [nil, []],
    ].map { |x| Struct.new(:data, :results).new(*x) }.each do |example|

      describe "different examples" do

        it "should return the ids of the users" do

          url     = Object.new
          channel = Object.new

          PoxaAssist::RestApi.stubs(:generate_users_url)
                             .with(channel)
                             .returns url

          page = Object.new
          page.stubs(:read).returns example.data
          PoxaAssist::RestApi.stubs(:open).with(url).returns page

          results = PoxaAssist::RestApi.users_on channel

          results.must_equal example.results
            
        end

      end

    end

  end

  describe "generating a URL to request for all users" do

    [
      [ { host: 'localhost',
          port: 8080, 
          app_id: 'a',
          app_key: 'b',
          app_secret: 'c' }, 'presence-example', 
          1399319551,
          "http://localhost:8080/apps/a/channels/presence-example/users?auth_key=b&auth_timestamp=1399319551&auth_version=1.0&auth_signature=84cdf8253c9f5349d114a41e10a996d5bf31b200608103fa06660545ccc21364"],
      [ { host: 'localhost',
          port: 8081, 
          app_id: 'a',
          app_key: 'b',
          app_secret: 'c' }, 'presence-example', 
          1399319551,
          "http://localhost:8081/apps/a/channels/presence-example/users?auth_key=b&auth_timestamp=1399319551&auth_version=1.0&auth_signature=84cdf8253c9f5349d114a41e10a996d5bf31b200608103fa06660545ccc21364"],
      [ { host: 'localhost',
          port: 8080, 
          app_id: 'a',
          app_key: 'b',
          app_secret: 'c' }, 'presence-example', 
          1399322468,
          "http://localhost:8080/apps/a/channels/presence-example/users?auth_key=b&auth_timestamp=1399322468&auth_version=1.0&auth_signature=de5a9ba8e4f9346c0df257854aa61ddb172251b75f9adec4206d8c08749ce716"],
      [ { host: '127.0.0.1',
          port: 3000, 
          app_id: 'x',
          app_key: 'y',
          app_secret: 'z' }, 'different', 
          1399419551,
          "http://127.0.0.1:3000/apps/x/channels/different/users?auth_key=y&auth_timestamp=1399419551&auth_version=1.0&auth_signature=0838a0685a9c619f1f06f15c6a8ce5eb710b57191f26aba2c76c8899779e03ea"],
      [ { host: '127.0.0.1',
          port: 3000, 
          ssl_port: 8443,
          app_id: 'x',
          app_key: 'y',
          app_secret: 'z' }, 'different', 
          1399419551,
          "https://127.0.0.1:8443/apps/x/channels/different/users?auth_key=y&auth_timestamp=1399419551&auth_version=1.0&auth_signature=0838a0685a9c619f1f06f15c6a8ce5eb710b57191f26aba2c76c8899779e03ea"],
      [ { host: '127.0.0.1',
          port: 3000, 
          ssl_port: 0,
          app_id: 'x',
          app_key: 'y',
          app_secret: 'z' }, 'different', 
          1399419551,
          "http://127.0.0.1:3000/apps/x/channels/different/users?auth_key=y&auth_timestamp=1399419551&auth_version=1.0&auth_signature=0838a0685a9c619f1f06f15c6a8ce5eb710b57191f26aba2c76c8899779e03ea"],
    ].map { |x| Struct.new(:options, :channel, :now, :expected).new(*x) }.each do |example|

      describe "different examples" do

        describe "options provided as arguments" do

          it "should build a signed request according to the pusher rules" do

            Timecop.freeze Time.at(example.now)

            result = PoxaAssist::RestApi.generate_users_url example.channel, example.options

            result.must_equal example.expected
              
          end

        end

        describe "use the global arguments" do

          it "should build a signed request according to the pusher rules" do

            Timecop.freeze Time.at(example.now)

            config = Object.new
            config.stubs(:host).returns example.options[:host]
            config.stubs(:port).returns example.options[:port]
            config.stubs(:ssl_port).returns example.options[:ssl_port]
            config.stubs(:app_id).returns example.options[:app_id]
            config.stubs(:app_key).returns example.options[:app_key]
            config.stubs(:app_secret).returns example.options[:app_secret]

            PoxaAssist.stubs(:config).returns config

            result = PoxaAssist::RestApi.generate_users_url example.channel

            result.must_equal example.expected
              
          end

        end

      end

    end

  end

end
