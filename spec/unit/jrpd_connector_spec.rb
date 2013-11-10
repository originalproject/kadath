require 'kadath/jrpd_connector'
require_relative 'spec_helper'

describe JRPDConnector do

  before do
    Kadath.stubs(:gem_root).returns('root')
  end

  it "uses JRPD to open the kadath pd file" do
    publicize_class(JRPDConnector)
    JRPD::Patch.expects(:new).with('root/data/kadath.pd').returns('foo')
    jc = JRPDConnector.new
    jc.patch.must_equal 'foo'
    unpublicize_class(JRPDConnector)
  end

  it "sends arbitrary messages to the patch" do
    mock_patch = mock
    mock_patch.expects(:send_unstructured_message).with('foo')
    JRPD::Patch.stubs(:new).with('root/data/kadath.pd').returns(mock_patch)
    jc = JRPDConnector.new
    jc.send_to_patch('foo')
  end

  it "starts Pd audio" do
    mock_audio = mock
    mock_audio.expects(:start)
    JRPD::Audio.expects(:new).returns(mock_audio)
    jc = JRPDConnector.new
    jc.start_audio
  end

  it "stops Pd audio" do
    mock_audio = mock
    mock_audio.expects(:stop)
    JRPD::Audio.expects(:new).returns(mock_audio)
    jc = JRPDConnector.new
    jc.stop_audio
  end

end