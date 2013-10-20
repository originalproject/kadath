require 'kadath'
require_relative 'spec_helper'

describe Kadath do
  
  it "can have a renderer set" do
    Kadath.renderer = "foo"
    Kadath.renderer.must_equal "foo"
  end

  it "uses a default renderer if none is set" do
    Kadath.renderer = nil
    Kadath.renderer.wont_be_nil
  end

  it "can render something by delegating to the renderer" do
    renderer = mock(render: "awooga")
    Kadath.renderer = renderer
    Kadath.render("something").must_equal "awooga"
  end

end