require 'kadath'
require_relative 'spec_helper'

describe Kadath do
  
  before do
    stub(Pd::JRPDConnector).new { 'connector' }
    @stub_renderer = Object.new
    stub(@stub_renderer).render('something')
    stub(Pd::Renderer).new('connector') { @stub_renderer }
  end

  after do
    # reset module variables
    Kadath.instance_variable_set(:@renderer, nil)
    Kadath.instance_variable_set(:@connector, nil)
    Kadath.instance_variable_set(:@audio, nil)
    Kadath.instance_variable_set(:@gem_root, nil)
    Kadath.instance_variable_set(:@inventory, nil)
  end

  it "can render something by delegating to the default renderer" do
    Kadath.render('something')
    assert_received(@stub_renderer) { |r| r.render('something') }
  end

  it "can render the output of a block to the default renderer" do
    Kadath.render { 'something' }
    assert_received(@stub_renderer) { |r| r.render('something') }
  end

  it "can render a block which it runs in the context of an Inventory" do
    inv = Object.new
    stub(inv).pd('foo') { 'something' }
    stub(Inventory).new { inv }
    Kadath.render { pd('foo') }
    assert_received(inv) { |i| i.pd('foo') }    
    assert_received(@stub_renderer) { |r| r.render('something') }
  end

  it "can return the Kadath gem root directory path" do
    root = Pathname.new(__FILE__).parent.parent.parent.to_s
    Kadath.gem_root.must_equal root
  end

  it "can start & stop audio by delegating to the default audio object" do
    stub(Pd::JRPDConnector).new { 'connector' }
    audio = Object.new
    stub(audio).start
    stub(audio).stop
    stub(Audio).new('connector') { audio }
    Kadath.start_audio
    assert_received(audio) { |a| a.start }
    Kadath.stop_audio
    assert_received(audio) { |a| a.stop }
  end

end