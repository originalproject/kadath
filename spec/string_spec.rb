require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

require 'kadath/monkeypatches/string'
require 'kadath/pd_box'

describe String do

  it "returns a PdBox when you precede it with a tilda" do
    pdbox = ~"foo"
    pdbox.must_be_instance_of Kadath::PdBox
    pdbox.pd_object.must_equal "foo"
  end

end