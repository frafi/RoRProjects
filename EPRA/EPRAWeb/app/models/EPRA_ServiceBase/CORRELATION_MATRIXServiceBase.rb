module EPRA_ServiceBase
	class CORRELATION_MATRIXServiceBase
		def initialize()
			@_context = nil
			@_context = EPRAEntities.new()
			@_context.Configuration.LazyLoadingEnabled = true
		end
 #this is the default behavior anyway
		def GetCORRELATION_MATRIX(corr_matrix_id)
			cORRELATION_MATRIXs = @_context.CORRELATION_MATRIX.Where(x.corr_matrix_id == corr_matrix_id)
			if cORRELATION_MATRIXs.Count() > 0 then
				return cORRELATION_MATRIXs.First()
			else
				return nil
			end
		end

		def GetCORRELATION_MATRIXs()
			cORRELATION_MATRIXs = @_context.CORRELATION_MATRIX
			return cORRELATION_MATRIXs
		end

		def InsertCORRELATION_MATRIX(cORRELATION_MATRIX)
			@_context.CORRELATION_MATRIX.Add(cORRELATION_MATRIX)
			return @_context.SaveChanges() > 0
		end

		def InsertCORRELATION_MATRIX(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
			cORRELATION_MATRIX = CORRELATION_MATRIX.new()
			cORRELATION_MATRIX.corr_matrix_id = corr_matrix_id
			cORRELATION_MATRIX.corr_group = corr_group
			cORRELATION_MATRIX.corr_code1 = corr_code1
			cORRELATION_MATRIX.corr_code2 = corr_code2
			cORRELATION_MATRIX.corr_type = corr_type
			cORRELATION_MATRIX.id1_name = id1_name
			cORRELATION_MATRIX.id2_name = id2_name
			cORRELATION_MATRIX.correlation = correlation
			if self.InsertCORRELATION_MATRIX(cORRELATION_MATRIX) then
				return cORRELATION_MATRIX
			else
				return nil
			end
		end

		def UpdateCORRELATION_MATRIX(cORRELATION_MATRIX)
			return @_context.SaveChanges() > 0
		end

		def UpdateCORRELATION_MATRIX(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
			cORRELATION_MATRIX = self.GetCORRELATION_MATRIX(corr_matrix_id)
			cORRELATION_MATRIX.corr_group = corr_group
			cORRELATION_MATRIX.corr_code1 = corr_code1
			cORRELATION_MATRIX.corr_code2 = corr_code2
			cORRELATION_MATRIX.corr_type = corr_type
			cORRELATION_MATRIX.id1_name = id1_name
			cORRELATION_MATRIX.id2_name = id2_name
			cORRELATION_MATRIX.correlation = correlation
			if self.UpdateCORRELATION_MATRIX(cORRELATION_MATRIX) then
				return cORRELATION_MATRIX
			else
				return nil
			end
		end

		def DeleteCORRELATION_MATRIX(corr_matrix_id)
			cORRELATION_MATRIX = self.GetCORRELATION_MATRIX(corr_matrix_id)
			@_context.CORRELATION_MATRIX.Remove(cORRELATION_MATRIX)
			return @_context.SaveChanges() > 0
		end
	end
end