require 'kadath/network'
require_relative 'spec_helper'

describe Network do

  # TODO remove this horrible monkey patching shit and replace with
  # a proper stub. Currently I cannot figure out how to stub a method
  # with mocha so I can get the parameters the method was called with.
  before do
    # intercept Network.new and save parameters
    class Network
      alias :old_initialize :initialize
      attr_reader :options
      def initialize(options)
        @options = options
      end
    end
  end

  after do
    # undo Network monkeypatch
    class Network
      alias :initialize :old_initialize
    end
  end

  it "can create a network from a box" do
    box = mock
    box.expects(:id).returns("foo")
    network = Network.from_box(box)
    network.must_be_instance_of Network
    network.options[:graph].nodes.first.key.must_equal "foo"
  end

  it "can create a network from a string" do
    network = Network.from_string("foo")
    network.must_be_instance_of Network
    box = network.options[:graph].nodes.first.properties[:box]
    box.must_be_instance_of PdBox
    box.pd_object.must_equal "foo"
  end

  it "can create a network from an array of [inlet, box, outlet]" do
    box = mock
    box.expects(:id).returns("foo")
    network = Network.from_array([:bar, box, :baz])
    network.must_be_instance_of Network
    network.options[:graph].nodes.first.key.must_equal "foo"
    network.options[:inlet].must_equal :bar
    network.options[:outlet].must_equal :baz
  end

  it "can create a network from an array of [inlet, box]" do
    box = mock
    box.expects(:id).returns("foo")
    network = Network.from_array([:bar, box])
    network.must_be_instance_of Network
    network.options[:graph].nodes.first.key.must_equal "foo"
    network.options[:inlet].must_equal :bar
  end

  it "can create a network from an array of [box, outlet]" do
    box = mock
    box.expects(:id).returns("foo")
    network = Network.from_array([box, :baz])
    network.must_be_instance_of Network
    network.options[:graph].nodes.first.key.must_equal "foo"
    network.options[:outlet].must_equal :baz
  end

  it "can create a network from an array of [inlet, string, outlet]" do
    network = Network.from_array([:bar, "foo", :baz])
    network.must_be_instance_of Network
    box = network.options[:graph].nodes.first.properties[:box]
    box.must_be_instance_of PdBox
    box.pd_object.must_equal "foo"
    network.options[:inlet].must_equal :bar
    network.options[:outlet].must_equal :baz
  end

  it "can create a network from an array of [inlet, network, outlet]" do
    n = mock
    n.expects(:graph).returns("awooga")
    network = Network.from_array([:bar, n, :baz])
    network.must_be_instance_of Network
    network.options[:graph].must_equal "awooga"
    network.options[:inlet].must_equal :bar
    network.options[:outlet].must_equal :baz
  end

end