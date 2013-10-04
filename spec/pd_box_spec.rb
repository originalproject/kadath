require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

require 'kadath/pd_box'

include Kadath

describe PdBox do

  it "can be initialized with a Pd object string" do
    pdbox = PdBox.new("foo")
    pdbox.must_be_instance_of PdBox
    pdbox.pd_object.must_equal "foo"
  end

  it "must be initialized with a parameter" do
    -> { pdbox = PdBox.new(nil) }.must_raise RuntimeError
  end

  it "has a default in which is always the first in" do
    pdbox = PdBox.new("foo")
    pdbox.default_in.must_equal 0
  end    

  it "has a default out which is always the first out" do
    pdbox = PdBox.new("foo")
    pdbox.default_out.must_equal 0
  end 

  it "assumes it has any inlet you ask about" do
    pdbox = PdBox.new("foo")
    pdbox.has_in?(:bar).must_equal true
  end

  it "assumes it has any outlet you ask about" do
    pdbox = PdBox.new("foo")
    pdbox.has_out?(:bar).must_equal true
  end

end