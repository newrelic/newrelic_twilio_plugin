module NewRelicTwilio
  module Collectors
    class Base
      def initialize(account_sid, auth_token)
        @twilio = ::Twilio::REST::Client.new(account_sid, auth_token)
      end

      def subaccounts
        @twilio.accounts.list
      end

      def collect
        []
      end
    end
  end
end
