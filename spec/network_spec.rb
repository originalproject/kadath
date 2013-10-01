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

  it "has a current_out which can be specified with out and returns network for chaining" do
    box = mock_box
    box.expects(:has_out?).with(:baz).returns(true)
    n = Network.new(box)
    n.out(:baz).must_equal n
    n.current_out.must_equal :baz
  end

  it "has a current_in which defaults to the default in of the first box" do
    box = mock_box(default_in: :bar)
    n = Network.new(box)
    n.current_in.must_equal :bar
  end

  it "has a current_in which can be specified with in and returns network for chaining" do
    box = mock_box
    box.expects(:has_in?).with(:baz).returns(true)
    n = Network.new(box)
    n.in(:baz).must_equal n
    n.current_in.must_equal :baz
  end

  it "can be connected to another network via the default ins and outs" do
    box = mock_box(id: "box1", default_out: :bar)
    box2 = mock_box(id: "box2", default_in: :baz)
    n = Network.new(box)
    n << Network.new(box2)
    first_node = n.graph.nodes.first
    first_node.key.must_equal "box1"
    first_node.out.first.key.must_equal "box2"
    connection = first_node.out_edges.first
    connection.wont_be_nil
    connection.properties[:out].must_equal :bar
    connection.properties[:in].must_equal :baz
  end
  
  it "can be connected to another network via specified ins and outs" do
    box = mock_box(id: "box1")
    box.expects(:has_out?).with(:box1out).returns(true)
    box2 = mock_box(id: "box2")
    box2.expects(:has_in?).with(:box2in).returns(true)
    n = Network.new(box)
    n.out(:box1out) << Network.new(box2).in(:box2in)
    first_node = n.graph.nodes.first
    first_node.key.must_equal "box1"
    first_node.out.first.key.must_equal "box2"
    connection = first_node.out_edges.first
    connection.wont_be_nil
    connection.properties[:out].must_equal :box1out
    connection.properties[:in].must_equal :box2in
  end

  it "raises an exception if in is set to a nonexistent in" do
    box = mock_box
    box.expects(:has_in?).with(:bar).returns(false)
    n = Network.new(box)
    -> { n.in(:bar) }.must_raise RuntimeError
  end

  it "raises an exception if out is set to a nonexistent out" do
    box = mock_box
    box.expects(:has_out?).with(:bar).returns(false)
    n = Network.new(box)
    -> { n.out(:bar) }.must_raise RuntimeError
  end

  it "raises an exception if a network is connected that has no in to connect to"
  it "raises an exception if it has no out and a network is connected to it"
  it "has an entry node which is the node it was initialized with"
  it "has an exit node which is the last node added"

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