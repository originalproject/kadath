require 'superators19'

require_relative '../pd/box'

class String

  def wire_to(thing)
    Kadath::PdBox.new(self).wire_to(thing)
  end

  # NOTE we can't just include WireToOperator like we do in Network and PdBox
  # because then the > method of string stops the superator from working
  superator ">~" do |operand|
    self.wire_to(operand)
  end

end