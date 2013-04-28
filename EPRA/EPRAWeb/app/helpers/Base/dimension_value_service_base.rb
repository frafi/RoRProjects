require "service_base_initializer.rb"
require "EPRA_entities.rb"

module Base
  class DimensionValueServiceBase
    include ServiceBaseInitializer

    attr_accessor :context

		def initialize
			@context = nil
			@context = EPRAEntities.new
			@context.configuration.lazy_loading_enabled = true
		end

    def get_dimension_valu dimension_id, period_id
      dimension_values = Array.new
      @context.dimension_values.each do |x|
        if (x.id == dimension_id && x.period_id == period_id)
            dimension_values.push x
        end
      end
			if dimension_values.any?
				return dimension_values[0]
			else
				return nil
			end
		end

		def get_dimension_values
			return @context.dimension_values
		end

		def insert_dimension_value dimension_value
			@context.dimension_valuess.add dimension_value
			return @context.save_changes
		end

		def insert_dimension_value(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
			dimension_value = DimensionValue.new
			dimension_value.period_id = period_id
			dimension_value.id = dimension_id
			dimension_value.view_id = view_id
			dimension_value.value1 = dimension_value
			dimension_value.status = dimension_status
			dimension_value.comments = dimension_comments
			dimension_value.dist_to_target = dimension_dist_to_target
			dimension_value.change = dimension_change
			dimension_value.trend_status = dimension_trend_status
			dimension_value.trend_colour = dimension_trend_colour
			if insert_dimension_value dimension_value
				return dimension_value
			else
				return nil
			end
		end

		def update_dimension_value dimension_value
			return @context.save_changes
		end

		def update_dimension_value(period_id, dimension_id, view_id, dimension_value, dimension_status, dimension_comments, dimension_dist_to_target, dimension_change, dimension_trend_status, dimension_trend_colour)
			dimension_value = get_dimension_value dimension_id, period_id
			dimension_value.view_id = view_id
			dimension_value.value1 = dimension_value
			dimension_value.status = dimension_status
			dimension_value.comments = dimension_comments
			dimension_value.dist_to_target = dimension_dist_to_target
			dimension_value.change = dimension_change
			dimension_value.trend_status = dimension_trend_status
			dimension_value.trend_colour = dimension_trend_colour
			if update_dimension_value dimension_value
				return dimension_value
			else
				return nil
			end
		end

		def delete_dimension_value dimension_id, period_id
			dimension_value = get_dimension_value dimension_id, period_id
			@context.dimension_values.remove dimension_value
			return @context.save_changes
		end
	end
end