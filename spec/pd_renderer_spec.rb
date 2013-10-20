require 'kadath/pd_renderer'
require_relative 'spec_helper'

describe PdRenderer do

  before do
    publicize_class(PdRenderer)
  end

  after do
    unpublicize_class(PdRenderer)
  end

  it "can render a pd object to a block" do
    box = mock(pd_object: "foo")
    pdr = PdRenderer.new
    output = nil
    pdr.yield_object(box) { |s| output = s }
    output.must_equal "obj 0 0 foo"
  end

  it "renders each pd object at a different y offset" do
    box1 = mock(pd_object: "foo")
    box2 = mock(pd_object: "bar")
    pdr = PdRenderer.new
    output = nil
    pdr.yield_object(box1) { }
    pdr.yield_object(box2) { |s| output = s }
    output.must_equal "obj 0 32 bar"
  end

  it "will not render the same pd object twice" do
    box = stub(pd_object: "foo")
    pdr = PdRenderer.new
    output = 'never changed'
    pdr.yield_object(box) { }
    pdr.yield_object(box) { |s| output = s }
    output.must_equal 'never changed'
  end

  it "can render the boxes in a network, one at a time, to a block"

  it "can render a network, one object or connection at a time, to a block"

  # it "can render a pd box" do
  #   pdr = PdRenderer.new
  #   pdr.render_box("foo")
  # end

end