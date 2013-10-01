require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

require 'kadath/network'

include Kadath

def mock_box(options = {})
  box = mock
  box.expects(:id).returns(options[:id] || "foo")
  box.expects(:default_in).returns(options[:default_in])
  box.expects(:default_out).returns(options[:default_out])
  box
end

describe Network do
  
  it "can be created with a box as an argument" do
    n = Network.new(mock_box)
    n.must_be_instance_of Network
    n.graph.nodes.first.key.must_equal "foo"
  end

  it "has a current_out which defaults to the default out of the last box" do
    box = mock_box(default_out: :bar)
    n = Network.new(box)
    n.current_out.must_equal :bar
  end

  it "has a current_out which can be specified with out" do
    box = mock_box
    box.expects(:has_out?).with(:baz).returns(true)
    n = Network.new(box)
    n.out(:baz)
    n.current_out.must_equal :baz
  end

  it "has a current_in which defaults to the default in of the first box" do
    box = mock_box(default_in: :bar)
    n = Network.new(box)
    n.current_in.must_equal :bar
  end

  it "has a current_in which can be specified with in" do
    box = mock_box
    box.expects(:has_in?).with(:baz).returns(true)
    n = Network.new(box)
    n.in(:baz)
    n.current_in.must_equal :baz
  end

  it "can be connected to another network via the default ins and outs"
  it "can be connected to another network via specified ins and outs"
  it "raises an exception if in is set to a nonexistent in"
  it "raises an exception if out is set to a nonexistent out"
  it "raises an exception if a network is connected that has no in to connect to"
  it "raises an exception if it has no out and a network is connected to it"
  
    # box1 = mock
    # box1.expects(:out).once.returns(:out_1)
    # box2 = mock
    # box2.expects(:in).once
    # n = Network.new(box)
    # n << Network.

=begin  it "can have a box appended to it" do
    n = Network.new
    n << "box"
    [
      {
        box: box,
        connections: []
      }
    ]
=end

end