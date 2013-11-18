require_relative 'boxes/pd'

module Kadath
  class Inventory

    def pd(pd_object)
      Boxes::Pd.new(pd_object)
    end

  end
end