$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'sinatra'

get '/' do
  "Hello from TheLadders!"
end
