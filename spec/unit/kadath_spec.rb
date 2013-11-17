require 'kadath'
require_relative 'spec_helper'

describe Kadath do
  
  # it "defaults to a Pd::Renderer using Pd::JRPDConnector" do
  #   Kadath::Pd::JRPDConnector.expects(:new).returns('foo')
  #   Kadath::Pd::Renderer.expects(:new).with('foo').returns('bar')
  #   Kadath.send(:renderer).must_equal 'bar'
  # end

  it "can render something by delegating to the default renderer" do
    renderer = mock(render: "awooga")
    Kadath::Pd::JRPDConnector.expects(:new).returns('foo')
    Kadath::Pd::Renderer.expects(:new).with('foo').returns(renderer)
    Kadath.render("something").must_equal "awooga"

    # Fix problem with Mocha leaking mocks between tests :(
    Kadath::Pd::JRPDConnector.unstub(:new)
    Kadath::Pd::Renderer.unstub(:new)
  end

  it "can return the Kadath gem root directory path" do
    root = Pathname.new(__FILE__).parent.parent.parent.to_s
    Kadath.gem_root.must_equal root
  end

  it "can start & stop audio by delegating to the default audio object" do
    mock_audio = mock(start: nil, stop: nil)
    Kadath::Pd::JRPDConnector.stubs(:new).returns('foo')
    Kadath::Audio.expects(:new).with('foo').returns(mock_audio)
    Kadath.start_audio
    Kadath.stop_audio

    # Fix problem with Mocha leaking mocks between tests :(
    Kadath::Pd::JRPDConnector.unstub(:new)
    Kadath::Audio.unstub(:new)
  end

end