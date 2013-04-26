require "service_base_initializer.rb"
require "EPRA_entities.rb"

module Base
	class CorrelationTypeServiceBase
    include
		def initialize
      initialize_context
		end

		def get_correlation_type(corr_type_id)
      correlation_type_index = @context.correlation_types.index{|x| x.corr_type_id == corr_type_id}
      unless correlation_type_index.nil?
        return @context.correlation_types[correlation_type_index]
      end
      return nil
		end

		def get_correlation_types
			return @context.correlation_types
		end

		def insert_correlation_type correlation_type
			@context.correlation_types.add correlation_type
			return @context.save_changes
		end

		def insert_correlation_type corr_type_id, corr_type, corr_type_description
			correlation_type = correlation_type.new
			correlation_type.corr_type_id = corr_type_id
			correlation_type.corr_type = corr_type
			correlation_type.corr_type_description = corr_type_description
			if insert_correlation_type correlation_type
				return correlation_type
			else
				return nil
			end
		end

		def update_correlation_type correlation_type
			return @context.save_changes
		end

		def update_correlation_type corr_type_id, corr_type, corr_type_description
			correlation_type = get_correlation_type corr_type_id
			correlation_type.corr_type = corr_type
			correlation_type.corr_type_description = corr_type_description
			if update_correlation_type correlation_type
				return correlation_type
			else
				return nil
			end
		end

		def delete_correlation_type corr_type_id
			correlation_type = get_correlation_type corr_type_id
			@context.correlation_types.remove correlation_type
			return @context.save_changes
		end
	end
end