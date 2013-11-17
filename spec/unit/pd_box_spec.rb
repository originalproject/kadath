require 'kadath/boxes/pd'
require_relative 'spec_helper'

describe Pd::Box do

  it "can be initialized with a Pd object string" do
    pdbox = Pd::Box.new("foo")
    pdbox.must_be_instance_of Pd::Box
    pdbox.pd_object.must_equal "foo"
  end

  it "must be initialized with a parameter" do
    -> { pdbox = Pd::Box.new(nil) }.must_raise RuntimeError
  end

  it "has a default in which is always the first in" do
    pdbox = Pd::Box.new("foo")
    pdbox.default_inlet.must_equal 0
  end    

  it "has a default out which is always the first out" do
    pdbox = Pd::Box.new("foo")
    pdbox.default_outlet.must_equal 0
  end 

  it "assumes it has any inlet you ask about" do
    pdbox = Pd::Box.new("foo")
    pdbox.has_inlet?(:bar).must_equal true
  end

  it "assumes it has any outlet you ask about" do
    pdbox = Pd::Box.new("foo")
    pdbox.has_outlet?(:bar).must_equal true
  end

  it "has an id which is unique" do
    pdb1 = Pd::Box.new("foo")
    pdb2 = Pd::Box.new("bar")
    pdb1.id.wont_equal pdb2.id
  end

  it "can be appended with another pdbox to create a network" do
    pdb1 = Pd::Box.new("foo")
    pdb2 = Pd::Box.new("bar")
    n = pdb1 >~ pdb2
    n.must_be_instance_of Network
    n.inlet.must_equal 0
    n.outlet.must_equal 0
    n.graph.nodes.first.key.must_equal pdb1.id
    n.graph.nodes.last.key.must_equal pdb2.id
  end

end