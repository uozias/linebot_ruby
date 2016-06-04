require 'sinatra'
require './line_message'
require 'logger'
require 'json'

logdir = File.dirname(__FILE__) + "/log"
logger = ::Logger.new(logdir + '/app.log')

post '/' do
  from = nil
  params = JSON.parse request.body.read
  logger.debug "params: " + params.to_json
  from = params['result'][0]['from'] if params['result'].is_a? Array
  result = LineMessage.new.send(from)
  logger.debug "response: " + result.body.to_s
  logger.debug "from: " + from
  'OK ' + from.to_s
end



