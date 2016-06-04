require 'dotenv'
require 'faraday'
require 'json'

Dotenv.load

class LineMessage
  def send(from)
    from ||= ENV["TARGET_MID"]

    conn = Faraday.new(:url => 'https://trialbot-api.line.me') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    path = '/v1/events'
    body = {
        to: [from],
        toChannel: 1383378250,
        eventType: "138311608800106203",
        content: {
            contentType: 1,
            toType: 1,
            text:"Hello, Jose!"
        }
    }.to_json

    conn.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json; charset=UTF-8'
      req.headers['X-Line-ChannelID'] =  ENV['LINE_CHANNEL_ID']
      req.headers['X-Line-ChannelSecret'] = ENV['LINE_CHANNEL_SECRET']
      req.headers['X-Line-Trusted-User-With-ACL'] = ENV['LINE_CHANNEL_MID']
      req.body = body
    end
  end
end
