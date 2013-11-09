require 'kadath/audio'
require_relative 'spec_helper'

describe Audio do

  it "can be initialized with a Pd connector" do
    a = Audio.new('foo')
  end

  it "delegates the start_audio command to the Pd connector" do
    pdc = mock(start_audio: nil)
    a = Audio.new(pdc)
    a.start_audio
  end

  it "delegates the stop_audio command to the Pd connector" do
    pdc = mock(stop_audio: nil)
    a = Audio.new(pdc)
    a.stop_audio
  end

end