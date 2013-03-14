module EPRA_ServiceFacade
	class IndicatorTrendStatusCalculationService
		def GetIndicatorTrendStatus(indicatorValue)
			indicatorValues = indicatorValue.INDICATOR.INDICATOR_VALUE.Where(x.indicator_id == indicatorValue.indicator_id && x.view_id == indicatorValue.view_id && x.PeriodDate < indicatorValue.PeriodDate).OrderByDescending(x.PeriodDate)
			previousIndicatorValue = indicatorValues.Count() == 0 ? nil : indicatorValues.First()
			if previousIndicatorValue != nil then
				indicatorTrendStatusCalculation = EPRA.Domain.IndicatorTrendStatusCalculation.new()
				return indicatorTrendStatusCalculation.GetIndicatorTrendStatus(indicatorValue, previousIndicatorValue)
			else
				indicatorTrendStatus = IndicatorTrendStatus.new()
				indicatorTrendStatus.Change = 0
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowRight.png"
				return indicatorTrendStatus
			end
		end
	end
end