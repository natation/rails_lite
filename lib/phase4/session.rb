require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        @cookie_contents = JSON.parse(cookie.value) if cookie.name == '_rails_lite_app'
      end
      @cookie_contents ||= {}
    end

    def [](key)
      @cookie_contents[key]
    end

    def []=(key, val)
      @cookie_contents[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      value = @cookie_contents.to_json
      cookie = WEBrick::Cookie.new('_rails_lite_app', value)
      res.cookies << cookie
    end
  end
end
