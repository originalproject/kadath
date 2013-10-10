require_relative 'wire_to_operator'
require_relative 'network'

module Kadath
  class PdBox

    include WireToOperator

    attr_reader :pd_object

    def initialize(pd_object)
      if !pd_object
        fail "PdBox must be instantiated with a valid Pd object string"
      end
      @pd_object = pd_object
    end

    def id
      object_id
    end

    def default_inlet
      0
    end

    def default_outlet
      0
    end

    def has_inlet?(_)
      true
    end

    def has_outlet?(_)
      true
    end

    def wire_to(thing)
      n = Network.from_box(self)
      n.wire_to(thing)
    end

  end
end