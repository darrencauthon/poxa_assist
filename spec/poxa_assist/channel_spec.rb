require_relative '../spec_helper'

describe PoxaAssist::Channel do

  describe "triggering messages" do

    let(:pusher_channel) { Object.new }
    let(:channel)        { PoxaAssist::Channel.new pusher_channel }

    describe "triggering a message" do

      ['my_event', 'another'].each do |name|

        describe "with different messages" do

          it "should pass the information to the pusher channel" do
            data = { something: Object.new }
            pusher_channel.expects(:trigger).with(name, data)
            channel.trigger(name, data)
          end

          it "should work with symbols as well as strings" do
            data = { something: Object.new }
            pusher_channel.expects(:trigger).with(name, data)
            channel.trigger(name.to_sym, data)
          end

          it "should work without passing any data" do
            pusher_channel.expects(:trigger).with(name, {})
            channel.trigger(name.to_sym)
          end

        end

      end

    end

  end

end
