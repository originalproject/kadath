require 'superators19'

module Kadath
  module WireToOperator

    superator ">~" do |operand|
      self.wire_to(operand)
    end

  end
end