require 'kadath'
require_relative 'spec_helper'

describe Kadath do
  
  it "can have a renderer set" do
    Kadath.renderer = "foo"
    Kadath.renderer.must_equal "foo"
  end

  it "defaults to a PdRenderer using JRPDConnector" do
    Kadath.renderer = nil
    Kadath::JRPDConnector.expects(:new).returns('foo')
    Kadath::PdRenderer.expects(:new).with('foo').returns('bar')
    Kadath.renderer.must_equal 'bar'
  end

  it "can render something by delegating to the renderer" do
    renderer = mock(render: "awooga")
    Kadath.renderer = renderer
    Kadath.render("something").must_equal "awooga"
  end

  it "can return the Kadath gem root directory path" do
    root = Pathname.new(__FILE__).parent.parent.parent.to_s
    Kadath.gem_root.must_equal root
  end

end