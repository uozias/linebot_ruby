require 'sinatra'
require './line_message'

get '/' do
  LineMessage.new.send
  'OK'
end



