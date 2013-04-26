require "metric_trend_status.rb"
require "metric_trend_status_calculation.rb"

module Facade
	class MetricTrendStatusCalculationService

		def get_metric_trend_status metric_value
      # Filter out future values for current metric
      # Then sort by metric age
      @metric_values = Array.new
      metric_value.metric.metric_values.each do |x|
        if (x.metric_id == metric_value.metric_id &&
            x.view_id == metric_value.view_id &&
            x.period_date < metric_value.period_date)
            @metric_values.push x
        end
      end
      @metric_values.sort_by { |x| x.age  }

      previous_metric_value = nil
      if @metric_values.any?
        previous_metric_value = @metric_values[-1]
      end

			unless previous_metric_value.nil?
				metric_trend_status_calculation = MetricTrendStatusCalculation.new
				return metric_trend_status_calculation.get_metric_trend_status metric_value, previous_metric_value
			else
				metrict_trend_status = MetricTrendStatus.new
				metrict_trend_status.change = 0
				metrict_trend_status.change_image_url = "~/Images/Arrows/ArrowRight.png"
				return metrict_trend_status
			end

		end
	end
end