module EPRA_ServiceFacade
	class MetricTrendStatusCalculationService
		def GetMetricTrendStatus(metricValue)
			metricValues = metricValue.METRIC.METRIC_VALUE.Where(x.metric_id == metricValue.metric_id && x.view_id == metricValue.view_id && x.PeriodDate < metricValue.PeriodDate).OrderByDescending(x.PeriodDate)
			previousMetricValue = metricValues.Count() == 0 ? nil : metricValues.First()
			if previousMetricValue != nil then
				metricTrendStatusCalculation = EPRA.Domain.MetricTrendStatusCalculation.new()
				return metricTrendStatusCalculation.GetMetricTrendStatus(metricValue, previousMetricValue)
			else
				metricTrendStatus = MetricTrendStatus.new()
				metricTrendStatus.Change = 0
				metricTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowRight.png"
				return metricTrendStatus
			end
		end
	end
end