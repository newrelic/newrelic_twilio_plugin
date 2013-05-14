module NewRelicTwilio
  module Collectors
    class Usage < Base
      def account_data_points(account)
        account.usage.records.today.list.map do |record|
          [account.sid, record.category, record.usage]
        end
      end

      def collect
        subaccounts.each do |account|
          puts account_data_points(account).inspect
        end
        []
      end
    end
  end
end
