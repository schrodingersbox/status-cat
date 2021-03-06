module StatusCat
  module Checkers
    class Twilio < Base

      cattr_accessor :sid
      cattr_accessor :auth_token

      def initialize
        return if gem_missing?('twilio-ruby', defined?(::Twilio))

        @value = sid
        @status = fail_on_exception do
          twilio = ::Twilio::REST::Client.new(sid, auth_token)
          twilio.api.account.messages.list.count ? nil : 'fail'
        end
      end
    end
  end
end
