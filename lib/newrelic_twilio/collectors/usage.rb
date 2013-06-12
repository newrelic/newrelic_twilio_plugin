module NewRelicTwilio
  module Collectors
    class Usage < Base
      TOTAL_DATA_POINTS = %w[
        calls
        calls-inbound
        sms
        sms-inbound
        sms-outbound
        phonenumbers
        shortcodes
      ]

      def account_data_points(account)
        data_points = {}
        account.usage.records.today.list.each do |record|
          append_total = TOTAL_DATA_POINTS.include?(record.category)
          append = append_total ? "total" : record.usage_unit
          data_points["#{record.category}-#{append}"] = {
            "value" => record.usage.to_f,
            "unit"  => record.usage_unit,
            "day"   => record.start_date
          }
          append = append_total ? "total" : "count"
          data_points["#{record.category}-#{append}"] = {
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
              value = case metric_name
              when /^phonenumbers/
                point["value"]
              else
                point["value"] - last_point["value"]
              end
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
