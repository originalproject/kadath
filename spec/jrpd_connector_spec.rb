require 'kadath/jrpd_connector'
require_relative 'spec_helper'

KPDPATH = (Pathname.new(__FILE__).parent.parent + "data" + "kadath.pd").to_s

describe JRPDConnector do

  it "tells JRPD to open the kadath pd file when initialized" do
    JRPD::Patch.expects(:new).with(KPDPATH)
    jc = JRPDConnector.new
  end

  it "sends arbitrary messages to the patch" do
    mock_patch = mock
    mock_patch.expects(:send_unstructured_message).with('foo')
    JRPD::Patch.stubs(:new).with(KPDPATH).returns(mock_patch)
    jc = JRPDConnector.new
    jc.send_to_patch('foo')    
  end

end