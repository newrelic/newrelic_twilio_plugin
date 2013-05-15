module NewRelicTwilio
  module Collectors
    class Usage < Base
      def account_data_points(account)
        data_points = {}
        account.usage.records.today.list.each do |record|
          data_points["#{record.category}-#{record.usage_unit}"] = {
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

      def calculate_metrics
        metrics = []
        accounts.each do |account|
          component = account.friendly_name
          @last_data_points[component] ||= {}
          account_data_points(account).each do |metric_name, point|
            last_point = @last_data_points[component][metric_name]
            unless last_point.nil? || point["day"] != last_point["day"]
              value = point["value"] - last_point["value"]
              metrics << [component, metric_name, point["unit"], value]
            end
            @last_data_points[component][metric_name] = point
          end
        end
        metrics
      end

      def collect
        calculate_metrics
      end
    end
  end
end
