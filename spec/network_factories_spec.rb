require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

require 'kadath/network_factories'

include Kadath

class Harness
  include NetworkFactories
end

class Network
  attr_reader :options
  def initialize(options)
    @options = options
  end
end

describe NetworkFactories do

  it "can create a network from a box" do
    box = mock
    box.expects(:id).returns("foo")
    network = Harness.new.network_from_box(box)
    network.must_be_instance_of Network
    network.options[:graph].nodes.first.key.must_equal "foo"
  end

end