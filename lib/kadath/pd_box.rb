module Kadath
  class PdBox

    attr_reader :pd_object

    def initialize(pd_object)
      if !pd_object
        fail "PdBox must be instantiated with a valid Pd object string"
      end
      @pd_object = pd_object
    end

    def default_in
      0
    end

    def default_out
      0
    end

    def has_in?(_)
      true
    end

    def has_out?(_)
      true
    end

  end
end