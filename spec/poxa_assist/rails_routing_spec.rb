require_relative '../spec_helper'

describe PoxaAssist::RailsRouting do

  let(:routes) { Object.new }

  before do
    routes.stubs(:get)
    routes.stubs(:post)
  end

  it "should map the js pusher file" do
    routes.expects(:get).with('/js/pusher.min.js' => 'poxa#js_file')
    PoxaAssist::RailsRouting.inject_into routes
  end

  it "should map the auth method" do
    routes.expects(:post).with('/pusher/auth' => 'poxa#auth')
    PoxaAssist::RailsRouting.inject_into routes
  end

end
