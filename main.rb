require 'sinatra'
require './line_message'

get '/' do
  from = params['from']
  LineMessage.new.send(from)
  'OK'
end



