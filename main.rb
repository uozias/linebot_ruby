require 'sinatra'
require './line_message'
require 'logger'
require 'json'
require 'dotenv'

Dotenv.load

logger = ::Logger.new(ENV["BASE_PATH"].to_s + 'log/app.log')

post '/' do
  from = nil
  params = JSON.parse request.body.read
  logger.debug "params: " + params.to_json
  from = params['result'][0]['from'] if params['result'].is_a? Array

  content = {
      sticker_id: "13",
      sticker_package_id: "1"
  }

  # content = {
  #     text: "OKです",
  # }


  result = LineMessage.new.send(from, content)
  logger.debug "response: " + result.body.to_s
  logger.debug "from: " + from.to_s
  'OK ' + from.to_s
end



