module EPRA_Domain
	class IndicatorTrendStatusCalculation
		def GetIndicatorTrendStatus(indicatorValue, previousIndicatorValue)
			indicatorTrendStatus = IndicatorTrendStatus.new()
			if previousIndicatorValue.indicator_value1 != nil and previousIndicatorValue.indicator_value1 != 0 then
				indicatorTrendStatus.Change = ((indicatorValue.indicator_value1 - previousIndicatorValue.indicator_value1) / previousIndicatorValue.indicator_value1) == 0
			end
			#Arrow display driven by Change value
			#Set INDICATOR.indic_threshold1 = band1 and INDICATOR.indic_threshold2 = band 2
			#If (band1*-1) <= Change value <= band1, then arrow is flat
			#If (band 2*-1) <= Change value < (band1*-1), then arrow is 45 degree down
			#If Change value < (band2*-1), then arrow is vertical down
			#If band 1 < Change value <= band2, then arrow is 45 degree up
			#IF Change value > band2m then arrow is vertical up.
			if (indicatorValue.INDICATOR.indic_threshold1 == 0) * -1 <= indicatorTrendStatus.Change and indicatorTrendStatus.Change <= (indicatorValue.INDICATOR.indic_threshold1 == 0) then
				#flat
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowRight.png" #black
			elsif (indicatorValue.INDICATOR.indic_threshold2 == 0) * -1 <= indicatorTrendStatus.Change and indicatorTrendStatus.Change < (indicatorValue.INDICATOR.indic_threshold1 == 0) * -1 then
				#45 down
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowDown45.png" #black
			elsif indicatorTrendStatus.Change < (indicatorValue.INDICATOR.indic_threshold2 == 0) * -1 then
				#vert down
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowDown.png" #black
			elsif (indicatorValue.INDICATOR.indic_threshold1 == 0) < indicatorTrendStatus.Change and indicatorTrendStatus.Change <= (indicatorValue.INDICATOR.indic_threshold2 == 0) then
				#45 up
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowUp45.png" #black
			elsif indicatorTrendStatus.Change > (indicatorValue.INDICATOR.indic_threshold2 == 0) then
				#vert up
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowUp.png"
			else #black
				indicatorTrendStatus.ChangeImageURL = "~/Images/Arrows/ArrowRight.png"
			end
			return indicatorTrendStatus
		end
	end
end