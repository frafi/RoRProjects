module EPRA_ServiceBase
	class DIMENSION_VALUEServiceBase
		def initialize()
			@_context = nil
			@_context = EPRAEntities.new()
			@_context.Configuration.LazyLoadingEnabled = true
		end
 #this is the default behavior anyway
		def GetDIMENSION_VALUE(dimension_id, period_id)
			dIMENSION_VALUEs = @_context.DIMENSION_VALUE.Where(x.dimension_id == dimension_id && x.period_id == period_id)
			if dIMENSION_VALUEs.Count() > 0 then
				return dIMENSION_VALUEs.First()
			else
				return nil
			end
		end

		def GetDIMENSION_VALUEs()
			dIMENSION_VALUEs = @_context.DIMENSION_VALUE
			return dIMENSION_VALUEs
		end

		def InsertDIMENSION_VALUE(dIMENSION_VALUE)
			@_context.DIMENSION_VALUE.Add(dIMENSION_VALUE)
			return @_context.SaveChanges() > 0
		end

		def InsertDIMENSION_VALUE(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
			dIMENSION_VALUE = DIMENSION_VALUE.new()
			dIMENSION_VALUE.period_id = period_id
			dIMENSION_VALUE.dimension_id = dimension_id
			dIMENSION_VALUE.view_id = view_id
			dIMENSION_VALUE.dimension_value1 = dimension_value
			dIMENSION_VALUE.dimension_status = dimension_status
			dIMENSION_VALUE.dimension_comments = dimension_comments
			dIMENSION_VALUE.dimension_dist_to_target = dimension_dist_to_target
			dIMENSION_VALUE.dimension_change = dimension_change
			dIMENSION_VALUE.dimension_trend_status = dimension_trend_status
			dIMENSION_VALUE.dimension_trend_colour = dimension_trend_colour
			if self.InsertDIMENSION_VALUE(dIMENSION_VALUE) then
				return dIMENSION_VALUE
			else
				return nil
			end
		end

		def UpdateDIMENSION_VALUE(dIMENSION_VALUE)
			return @_context.SaveChanges() > 0
		end

		def UpdateDIMENSION_VALUE(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
			dIMENSION_VALUE = self.GetDIMENSION_VALUE(dimension_id, period_id)
			dIMENSION_VALUE.view_id = view_id
			dIMENSION_VALUE.dimension_value1 = dimension_value
			dIMENSION_VALUE.dimension_status = dimension_status
			dIMENSION_VALUE.dimension_comments = dimension_comments
			dIMENSION_VALUE.dimension_dist_to_target = dimension_dist_to_target
			dIMENSION_VALUE.dimension_change = dimension_change
			dIMENSION_VALUE.dimension_trend_status = dimension_trend_status
			dIMENSION_VALUE.dimension_trend_colour = dimension_trend_colour
			if self.UpdateDIMENSION_VALUE(dIMENSION_VALUE) then
				return dIMENSION_VALUE
			else
				return nil
			end
		end

		def DeleteDIMENSION_VALUE(dimension_id, period_id)
			dIMENSION_VALUE = self.GetDIMENSION_VALUE(dimension_id, period_id)
			@_context.DIMENSION_VALUE.Remove(dIMENSION_VALUE)
			return @_context.SaveChanges() > 0
		end
	end
end