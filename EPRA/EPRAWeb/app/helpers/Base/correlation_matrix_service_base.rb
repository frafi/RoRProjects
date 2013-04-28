require "service_base_initializer.rb"
require "EPRA_entities.rb"

module Base
	class CorrelationMatrixServiceBase
    include ServiceBaseInitializer

    attr_accessor :context

		def initialize
      initialize_context
		end

		def get_correlation_matrix(corr_matrix_id)
      correlation_matrix_index = @context.correlation_matrices.index{|x| x.matrix_id == corr_matrix_id}
      unless correlation_matrix_index.nil?
        return @context.correlation_matrices[correlation_matrix_index]
      end
      return nil
		end

		def get_correlation_matrices
			return @context.correlation_matrices
		end

		def insert_correlation_matrix correlation_matrix
			@context.correlation_matrices.add correlation_matrix
			return @context.save_changes
		end

		def insert_correlation_matrix(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
			correlation_matrix = CorrelationMatrix.new
			correlation_matrix.matrix_id = corr_matrix_id
			correlation_matrix.group = corr_group
			correlation_matrix.code1 = corr_code1
			correlation_matrix.code2 = corr_code2
			correlation_matrix.type = corr_type
			correlation_matrix.id1_name = id1_name
			correlation_matrix.id2_name = id2_name
			correlation_matrix.correlation = correlation
			if insert_correlation_matrix correlation_matrix
				return correlation_matrix
			else
				nil
			end
		end

		def update_correlation_matrix correlation_matrix
			@context.save_changes
		end

		def update_correlation_matrix(corr_matrix_id, corr_group, corr_code1, corr_code2, corr_type, id1_name, id2_name, correlation)
			correlation_matrix = get_correlation_matrix corr_matrix_id
			correlation_matrix.group = corr_group
			correlation_matrix.code1 = corr_code1
			correlation_matrix.code2 = corr_code2
			correlation_matrix.type = corr_type
			correlation_matrix.id1_name = id1_name
			correlation_matrix.id2_name = id2_name
			correlation_matrix.correlation = correlation
      if update_correlation_matrix correlation_matrix
				return correlation_matrix
      end
		end

		def delete_correlation_matrix corr_matrix_id
			correlation_matrix = get_correlation_matrix corr_matrix_id
			@context.correlation_matrices.remove correlation_matrix
			@context.save_changes
		end
	end
end