require_relative '../pd_box'

class String

  def ~
    Kadath::PdBox.new(self)
  end

end