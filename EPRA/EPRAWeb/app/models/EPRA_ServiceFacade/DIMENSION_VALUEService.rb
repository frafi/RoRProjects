module EPRA_ServiceFacade
	class DIMENSION_VALUEService < DIMENSION_VALUEServiceBase
		def GetDIMENSION_VALUE(dimension_id, period_id)
			return self.GetDIMENSION_VALUE(dimension_id, period_id)
		end

		def GetDIMENSION_VALUEs()
			return self.GetDIMENSION_VALUEs()
		end

		def InsertDIMENSION_VALUE(dIMENSION_VALUE)
			return self.InsertDIMENSION_VALUE(dIMENSION_VALUE)
		end

		def InsertDIMENSION_VALUE(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
			return self.InsertDIMENSION_VALUE(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
		end

		def UpdateDIMENSION_VALUE(dIMENSION_VALUE)
			return self.UpdateDIMENSION_VALUE(dIMENSION_VALUE)
		end

		def UpdateDIMENSION_VALUE(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
			return self.UpdateDIMENSION_VALUE(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
		end

		def DeleteDIMENSION_VALUE(dimension_id, period_id)
			return self.DeleteDIMENSION_VALUE(dimension_id, period_id)
		end
	end
end