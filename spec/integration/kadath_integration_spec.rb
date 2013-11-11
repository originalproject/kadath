require 'kadath'
require_relative 'spec_helper'

describe "KADATH" do
  
  it "can apparently render a simple audio network" do
    network = "osc~ 440" >~ "dac~"
    Kadath.render(network)
  end

  it "can apparently render a simple audio network and play its output" do
    network = "osc~ 440" >~ "dac~"
    Kadath.render(network)
    Kadath.start_audio
    sleep(1)
    Kadath.stop_audio
  end

end