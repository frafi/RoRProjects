module EPRA_ServiceBase
	class CORRELATION_TYPEServiceBase
		def initialize()
			@_context = nil
			@_context = EPRAEntities.new()
			@_context.Configuration.LazyLoadingEnabled = true
		end
 #this is the default behavior anyway
		def GetCORRELATION_TYPE(corr_type_id)
			cORRELATION_TYPEs = @_context.CORRELATION_TYPE.Where(x.corr_type_id == corr_type_id)
			if cORRELATION_TYPEs.Count() > 0 then
				return cORRELATION_TYPEs.First()
			else
				return nil
			end
		end

		def GetCORRELATION_TYPEs()
			cORRELATION_TYPEs = @_context.CORRELATION_TYPE
			return cORRELATION_TYPEs
		end

		def InsertCORRELATION_TYPE(cORRELATION_TYPE)
			@_context.CORRELATION_TYPE.Add(cORRELATION_TYPE)
			return @_context.SaveChanges() > 0
		end

		def InsertCORRELATION_TYPE(corr_type_id, corr_type, corr_type_description)
			cORRELATION_TYPE = CORRELATION_TYPE.new()
			cORRELATION_TYPE.corr_type_id = corr_type_id
			cORRELATION_TYPE.corr_type = corr_type
			cORRELATION_TYPE.corr_type_description = corr_type_description
			if self.InsertCORRELATION_TYPE(cORRELATION_TYPE) then
				return cORRELATION_TYPE
			else
				return nil
			end
		end

		def UpdateCORRELATION_TYPE(cORRELATION_TYPE)
			return @_context.SaveChanges() > 0
		end

		def UpdateCORRELATION_TYPE(corr_type_id, corr_type, corr_type_description)
			cORRELATION_TYPE = self.GetCORRELATION_TYPE(corr_type_id)
			cORRELATION_TYPE.corr_type = corr_type
			cORRELATION_TYPE.corr_type_description = corr_type_description
			if self.UpdateCORRELATION_TYPE(cORRELATION_TYPE) then
				return cORRELATION_TYPE
			else
				return nil
			end
		end

		def DeleteCORRELATION_TYPE(corr_type_id)
			cORRELATION_TYPE = self.GetCORRELATION_TYPE(corr_type_id)
			@_context.CORRELATION_TYPE.Remove(cORRELATION_TYPE)
			return @_context.SaveChanges() > 0
		end
	end
end