require 'sinatra'
require './line_message'

configure do
  set :logging, Logger::DEBUG
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

post '/' do
  from = nil
  params = JSON.parse request.body.read
  logger.debug params.to_s
  from = params['result'][0]['from'] if params['result'].is_a? Array
  LineMessage.new.send(from)
  logger.debug "from: " + from.to_s
  'OK ' + from.to_s
end



