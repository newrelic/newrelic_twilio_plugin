module NewRelicTwilio
  module Collectors
    class Usage < Base
      def account_data_points(account)
        data_points = {}
        account.usage.records.today.list.each do |record|
          data_points[record.category] = {
            "value" => record.usage.to_f,
            "unit"  => record.usage_unit,
            "day"   => record.start_date
          }
          data_points["#{record.category}-count"] = {
            "value" => record.count.to_f,
            "unit"  => record.count_unit,
            "day"   => record.start_date
          }
        end
        data_points
      end

      def collect
        @last_data_points ||= {}
        new_data_points     = {}
        subaccounts.each do |account|
          new_data_points[account.friendly_name] = account_data_points(account)
        end
        metrics = []
        new_data_points.each do |component, data_points|
          data_points.each do |metric_name, details|
            begin
              last_details = @last_data_points[component][metric_name]
              if details["day"] == last_details["day"]
                value = details["value"] - last_details["value"]
                metrics << [component, metric_name, details["unit"], value]
              end
            rescue; end
          end
        end
        @last_data_points = new_data_points
        metrics
      end
    end
  end
end
