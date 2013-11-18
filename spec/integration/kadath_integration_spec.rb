require 'kadath'
require 'kadath/boxes/pd'
require_relative 'spec_helper'

describe "KADATH" do
  
  it "can apparently render a simple audio network" do
    Kadath.render {
      pd('osc~ 440') >~ pd('dac~')
    }
  end

  it "can apparently render a simple audio network and play its output" do
    Kadath.render {
      pd('osc~ 440') >~ pd('dac~')
    }
    Kadath.start_audio
    sleep(1)
    Kadath.stop_audio
  end

end