require "indicator_trend_status_calculation.rb"
require "indicator_trend_status.rb"

module Facade
	class IndicatorTrendStatusCalculationService
		def get_indicator_trend_status indicator_value
      # Filter out future values for current indicator
      # Then sort by indicator age
      @indicator_values = Array.new
      indicator_value.indicator.indicator_values.each do |x|
        if (x.indicator_id == indicator_value.indicator_id &&
            x.view_id == indicator_value.view_id &&
            x.period_date < indicator_value.period_date)
            @indicator_values.push x
        end
      end
      @indicator_values.sort_by { |x| x.age  }

      previous_indicator_value = nil
      if @indicator_values.any?
        previous_indicator_value = @indicator_values[-1]
      end

			unless previous_indicator_value.nil?
				indicator_trend_status_calculation = IndicatorTrendStatusCalculation.new
				return indicator_trend_status_calculation.get_indicator_trend_status indicator_value, previous_indicator_value
			else
				indicator_trend_status = IndicatorTrendStatus.new
				indicator_trend_status.change = 0
				indicator_trend_status.change_image_url = "~/Images/Arrows/ArrowRight.png"
				return indicator_trend_status
			end
		end
	end
end