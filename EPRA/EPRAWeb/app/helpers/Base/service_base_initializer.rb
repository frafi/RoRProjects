module Base
  module ServiceBaseInitializer
    def initialize_context
      @context = nil
			@context = EPRAEntities.new
			@context.configuration.lazy_loading_enabled = true
    end
  end
end
