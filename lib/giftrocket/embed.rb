require 'jwt'

module Giftrocket
  class Embed
    def self.tokenize(payload)
      JWT.encode(
        payload,
        Giftrocket.config[:access_token],
        'HS256'
      )
    end
  end
end
