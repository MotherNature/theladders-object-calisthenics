$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'server'
require 'rspec'
require 'rack/test'

set :environment, :test

describe "The Jobseeker app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello from TheLadders!'
  end

  it "accepts Recruiter profile submissions" do
    post '/recruiters', { :name => "Jane Smith" }
    last_response.should be_ok
    last_response.body.should match /Added new Recruiter: Jane Smith, ID: .*\./
  end
end
