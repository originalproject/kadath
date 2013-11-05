require 'kadath/jrpd_connector'
require_relative 'spec_helper'

describe JRPDConnector do

  before do
    Kadath.stubs(:gem_root).returns('root')
  end

  it "tells JRPD to open the kadath pd file when initialized" do
    JRPD::Patch.expects(:new).with('root/data/kadath.pd')
    jc = JRPDConnector.new
  end

  it "sends arbitrary messages to the patch" do
    mock_patch = mock
    mock_patch.expects(:send_unstructured_message).with('foo')
    JRPD::Patch.stubs(:new).with('root/data/kadath.pd').returns(mock_patch)
    jc = JRPDConnector.new
    jc.send_to_patch('foo')    
  end

end