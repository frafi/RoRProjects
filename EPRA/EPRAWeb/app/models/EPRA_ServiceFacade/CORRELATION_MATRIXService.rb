module EPRA_ServiceFacade
	class CORRELATION_MATRIXService < CORRELATION_MATRIXServiceBase
		def GetCORRELATION_MATRIX(corr_matrix_id)
			return self.GetCORRELATION_MATRIX(corr_matrix_id)
		end

		def GetCORRELATION_MATRIXs()
			return self.GetCORRELATION_MATRIXs()
		end

		def InsertCORRELATION_MATRIX(cORRELATION_MATRIX)
			return self.InsertCORRELATION_MATRIX(cORRELATION_MATRIX)
		end

		def InsertCORRELATION_MATRIX(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
			return self.InsertCORRELATION_MATRIX(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
		end

		def UpdateCORRELATION_MATRIX(cORRELATION_MATRIX)
			return self.UpdateCORRELATION_MATRIX(cORRELATION_MATRIX)
		end

		def UpdateCORRELATION_MATRIX(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
			return self.UpdateCORRELATION_MATRIX(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
		end

		def DeleteCORRELATION_MATRIX(corr_matrix_id)
			return self.DeleteCORRELATION_MATRIX(corr_matrix_id)
		end
	end
end