module NewRelicTwilio
  module Collectors
    class Usage < Base
      def subaccounts
        @twilio.accounts
      end

      def collect
        puts subaccounts.inspect
        []
      end
    end
  end
end
