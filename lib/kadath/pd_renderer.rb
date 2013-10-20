module Kadath
  class PdRenderer

    private

    Y_SPACING = 32

    def yield_object(pd_box)
      return if box_registered?(pd_box)
      index = register_box(pd_box)
      yield "obj 0 #{ index * Y_SPACING } #{ pd_box.pd_object }"
    end

    def box_registered?(pd_box)
      registry.has_key?(pd_box.object_id)
    end

    def register_box(pd_box)
      registry[pd_box.object_id] = take_registry_index!
    end

    def registry
      @registry ||= {}
    end

    def take_registry_index!
      @registry_index = (@registry_index || -1) + 1
    end

  end
end