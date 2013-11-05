require 'kadath'
require_relative 'spec_helper'

describe "KADATH" do
  
  it "can apparently render a simple audio network" do
    network = "osc~ 440" >~ "dac~"
    Kadath.render(network)
  end

end