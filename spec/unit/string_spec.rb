require 'kadath/monkeypatches/string'
require_relative 'spec_helper'

describe String do

  it "can create a PdBox and network it with other objects using the >~ superator" do
    network = "foo" >~ "bar"
    network.must_be_instance_of Kadath::Network
    network.graph.nodes.first.properties[:box].pd_object.must_equal "foo"
  end

end