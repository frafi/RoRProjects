module EPRA_ServiceBase
	class AGGREGATION_METHODServiceBase
		def initialize()
			@_context = nil
			@_context = EPRAEntities.new()
			@_context.Configuration.LazyLoadingEnabled = true
		end
 #this is the default behavior anyway
		def GetAGGREGATION_METHOD(aggreg_method)
			aGGREGATION_METHODs = @_context.AGGREGATION_METHOD.Where(x.aggreg_method == aggreg_method)
			if aGGREGATION_METHODs.Count() > 0 then
				return aGGREGATION_METHODs.First()
			else
				return nil
			end
		end

		def GetAGGREGATION_METHODs()
			aGGREGATION_METHODs = @_context.AGGREGATION_METHOD
			return aGGREGATION_METHODs
		end

		def InsertAGGREGATION_METHOD(aGGREGATION_METHOD)
			@_context.AGGREGATION_METHOD.Add(aGGREGATION_METHOD)
			return @_context.SaveChanges() > 0
		end

		def InsertAGGREGATION_METHOD(aggreg_method, aggreg_name, aggreg_description)
			aGGREGATION_METHOD = AGGREGATION_METHOD.new()
			aGGREGATION_METHOD.aggreg_method = aggreg_method
			aGGREGATION_METHOD.aggreg_name = aggreg_name
			aGGREGATION_METHOD.aggreg_description = aggreg_description
			if self.InsertAGGREGATION_METHOD(aGGREGATION_METHOD) then
				return aGGREGATION_METHOD
			else
				return nil
			end
		end

		def UpdateAGGREGATION_METHOD(aGGREGATION_METHOD)
			return @_context.SaveChanges() > 0
		end

		def UpdateAGGREGATION_METHOD(aggreg_method, aggreg_name, aggreg_description)
			aGGREGATION_METHOD = self.GetAGGREGATION_METHOD(aggreg_method)
			aGGREGATION_METHOD.aggreg_name = aggreg_name
			aGGREGATION_METHOD.aggreg_description = aggreg_description
			if self.UpdateAGGREGATION_METHOD(aGGREGATION_METHOD) then
				return aGGREGATION_METHOD
			else
				return nil
			end
		end

		def DeleteAGGREGATION_METHOD(aggreg_method)
			aGGREGATION_METHOD = self.GetAGGREGATION_METHOD(aggreg_method)
			@_context.AGGREGATION_METHOD.Remove(aGGREGATION_METHOD)
			return @_context.SaveChanges() > 0
		end
	end
end