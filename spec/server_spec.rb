$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'server'
require 'rspec'
require 'rack/test'

set :environment, :test

describe "The HelloFromTheLadders app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello from TheLadders!'
  end
end
