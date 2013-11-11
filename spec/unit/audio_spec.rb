require 'kadath/audio'
require_relative 'spec_helper'

describe Audio do

  it "can be initialized with a Pd connector" do
    a = Audio.new('foo')
  end

  it "delegates the start command to the Pd connector start_audio" do
    pdc = mock(start_audio: nil)
    a = Audio.new(pdc)
    a.start
  end

  it "delegates the stop command to the Pd connector stop_audio" do
    pdc = mock(stop_audio: nil)
    a = Audio.new(pdc)
    a.stop
  end

end