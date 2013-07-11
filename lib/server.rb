$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'labels'
require 'sinatra'

get '/' do
  "Hello from TheLadders!"
end

post '/recruiters' do
  name = Name.new(params[:name])
  id = 1
  "Added new Recruiter: #{name.to_s}, ID: #{id}."
end

