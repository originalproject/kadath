require 'kadath'
require 'kadath/pd/box'
require_relative 'spec_helper'

describe "KADATH" do
  
  it "can apparently render a simple audio network" do
    network = Kadath::Pd::Box.new("osc~ 440") >~ Kadath::Pd::Box.new("dac~")
    Kadath.render(network)
  end

  it "can apparently render a simple audio network and play its output" do
    network = Kadath::Pd::Box.new("osc~ 440") >~ Kadath::Pd::Box.new("dac~")
    Kadath.render(network)
    Kadath.start_audio
    sleep(1)
    Kadath.stop_audio
  end

end