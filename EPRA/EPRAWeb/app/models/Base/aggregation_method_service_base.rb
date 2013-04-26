require "service_base_initializer.rb"
require "EPRA_entities.rb"

module Base
	class AggregationMethodServiceBase
    attr_accessor :context

		def initialize
      initialize_context
		end

    def get_aggregation_method aggreg_method_name
      aggreg_method_index = @context.aggregation_methods.index{|x| x.name == aggreg_method_name}
      unless aggreg_method_index.nil?
        return @context.aggregation_methods[aggreg_method_index]
      end
      return nil
		end

		def get_aggregation_methods
			return @context.aggregation_methods
		end

		def insert_aggregation_method(aggregation_method)
      existing_aggreg_method_index = @context.aggregation_methods.index{|x| x.code == aggregation_method.code}
      if existing_aggreg_method_index.nil?
        @context.aggregation_methods.push(aggregation_method)
      else
        update_aggregation_method(aggregation_method)
      end
      return @context.save_changes
		end

		def insert_aggregation_method(method_name, aggreg_code, aggreg_description)
			aggregation_method = Aggregation_method.new
			aggregation_method.name = method_name
			aggregation_method.code = aggreg_code
			aggregation_method.description = aggreg_description
			if insert_aggregation_method(aggregation_method)
				return aggregation_method
			else
				return nil
			end
		end

		def update_aggregation_method aggregation_method
      aggreg_method_index = @context.aggregation_methods.index{|x| x.code == aggregation_method.code}
      unless aggreg_method_index.nil?
        @context.aggregation_methods[aggreg_method_index] = aggregation_method
        return @context.save_changes
      end
      return false
		end

		def update_aggregation_method aggreg_method_name, aggreg_description
			aggregation_method = get_aggregation_method aggreg_method_name
			aggregation_method.name = aggreg_method_name
			aggregation_method.description = aggreg_description
			if update_aggregation_method(aggregation_method)
				return aggregation_method
			else
				return nil
			end
		end

		def delete_aggregation_method aggreg_method_name
			aggregation_method = get_aggregation_method aggreg_method_name
			@context.aggregation_method.remove aggregation_method
			return @context.save_changes
		end
	end
end