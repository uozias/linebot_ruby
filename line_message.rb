require 'dotenv'
require 'faraday'
require 'json'

Dotenv.load

class LineMessage
  def send(from, content = {text: "hi!"})
    from ||= ENV["TARGET_MID"]

    conn = Faraday.new(:url => 'https://trialbot-api.line.me') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    content2 = build_content(content)
    return if content2.nil?

    path = '/v1/events'
    body = {
        to: [from],
        toChannel: 1383378250,
        eventType: "138311608800106203",
        content: content2
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

  def build_content(content)
    case content
      when String
        {
            contentType: 1,
            toType: 1,
            text: content
        }
      when Hash
        if content.has_key? :text
          {
              contentType: 1,
              toType: 1,
              text: content[:text]
          }
        end
        if content.has_key? :image_url
          {
              "contentType":2,
              "toType":1,
              "originalContentUrl": content[:image_url],
              "previewImageUrl": content[:preview_url]
          }
        end
        if content.has_key? :sticker_id
          {
              "contentType":8,
              "toType":1,
              "contentMetadata":{
                  "STKID": content[:sticker_id],
                  "STKPKGID": content[:sticker_package_id],
              }
          }
        end
      else
        nil
    end
  end
end
