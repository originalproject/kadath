require 'kadath'
require 'kadath/boxes/pd'
require_relative 'spec_helper'

describe "KADATH" do
  
  it "can apparently render a simple audio network" do
    network = Kadath::Boxes::Pd.new("osc~ 440") >~ Kadath::Boxes::Pd.new("dac~")
    Kadath.render(network)
  end

  it "can apparently render a simple audio network and play its output" do
    network = Kadath::Boxes::Pd.new("osc~ 440") >~ Kadath::Boxes::Pd.new("dac~")
    Kadath.render(network)
    Kadath.start_audio
    sleep(1)
    Kadath.stop_audio
  end

end