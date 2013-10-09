require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

require 'kadath/network'

include Kadath

def mock_box(options = {})
  id = options[:id] || "foo"
  has_inlet = options[:h_in]
  has_outlet = options[:h_out]
  default_inlet = options[:d_in]
  default_outlet = options[:d_out]

  box = mock
  box.expects(:id).at_least_once.returns(id) # if id
  box.expects(:has_inlet?).at_least_once.with(has_inlet).returns(true) if has_inlet
  box.expects(:has_outlet?).at_least_once.with(has_outlet).returns(true) if has_outlet
  if default_inlet
    box.expects(:default_inlet).at_least_once.returns(default_inlet)
  else
    box.expects(:default_inlet).at_least_once
  end
  if default_outlet
    box.expects(:default_outlet).at_least_once.returns(default_outlet)
  else
    box.expects(:default_outlet).at_least_once
  end
  box
end

describe Network do

  it "has an outlet which defaults to the default outlet of the last box" do
    box = mock_box(d_out: :baz)
    n = Network.from_box(box)
    n.outlet.must_equal :baz
  end

  it "has an inlet which defaults to the default inlet of the first box" do
    box = mock_box(d_in: :bar)
    n = Network.from_box(box)
    n.inlet.must_equal :bar
  end

  it "raises an exception if in is set to a nonexistent in"
  #   box = mock_box
  #   box.expects(:has_in?).with(:bar).returns(false)
  #   n = Network.new(box)
  #   -> { n.in(:bar) }.must_raise RuntimeError
  # end

  it "raises an exception if out is set to a nonexistent out"
  #   box = mock_box
  #   box.expects(:has_out?).with(:bar).returns(false)
  #   n = Network.new(box)
  #   -> { n.out(:bar) }.must_raise RuntimeError
  # end

  it "can be connected to another network" do
    box1 = mock_box(id: "box1", d_in: :poo, d_out: :bar)
    box2 = mock_box(id: "box2", d_in: :baz, d_out: :pah)
    n1 = Network.from_box(box1)
    n2 = Network.from_box(box2)
    n = n1.wire_to(n2)
    n.first_node.key.must_equal "box1"
    n.first_node.out.first.key.must_equal "box2"
    n.last_node.key.must_equal "box2"
    connection = n.first_node.out_edges.first
    connection.wont_be_nil
    connection.properties[:outlet].must_equal :bar
    connection.properties[:inlet].must_equal :baz
    n.inlet.must_equal :poo
    n.outlet.must_equal :pah
  end
  
  it "can be connected to another network using the >~ operator" do
    box1 = mock_box(id: "box1", d_in: :poo, d_out: :bar)
    box2 = mock_box(id: "box2", d_in: :baz, d_out: :pah)
    n1 = Network.from_box(box1)
    n2 = Network.from_box(box2)
    n = n1 >~ n2
    n.first_node.key.must_equal "box1"
    n.first_node.out.first.key.must_equal "box2"
    n.last_node.key.must_equal "box2"
    connection = n.first_node.out_edges.first
    connection.wont_be_nil
    connection.properties[:outlet].must_equal :bar
    connection.properties[:inlet].must_equal :baz
    n.inlet.must_equal :poo
    n.outlet.must_equal :pah
  end
    
  it "raises an exception if a network is connected that has no in to connect to" do
    box1 = mock_box(id: "box1", d_in: :poo, d_out: :bar)
    box2 = mock_box(id: "box2", d_out: :pah)
    n1 = Network.from_box(box1)
    n2 = Network.from_box(box2)
    -> { n1 >~ n2 }.must_raise RuntimeError
  end

  it "raises an exception if it has no out and a network is connected to it" do
    box1 = mock_box(id: "box1", d_in: :poo)
    box2 = mock_box(id: "box2", d_in: :baz, d_out: :pah)
    n1 = Network.from_box(box1)
    n2 = Network.from_box(box2)
    -> { n1 >~ n2 }.must_raise RuntimeError
  end

  it "can assemble a network of multiple networks"
  #   box = mock_box(id: "box1")
  #   box.expects(:has_out?).with(:box1out).returns(true)
  #   box2 = mock_box(id: "box2")
  #   box2.expects(:has_in?).with(:box2in).returns(true)
  #   box2.expects(:has_out?).with(:box2out).returns(true)
  #   box3 = mock_box(id: "box3", default_in: :box3in, default_out: :box3out)
  #   box4 = mock_box(id: "box4")
  #   box4.expects(:has_in?).with(:box4in).returns(true)
  #   n1 = Network.new(box)
  #   n2 = Network.new(box2)
  #   n3 = Network.new(box3)
  #   n4 = Network.new(box4)
  #   nn1 = n1.out(:box1out) << n2.in(:box2in)
  #   nn2 = n3 << n4.in(:box4in)
  #   n = nn1.out(:box2out) << nn2
  #   first_node = n.graph.nodes.first
  #   first_node.key.must_equal "box1"
  #   second_node = first_node.out.first
  #   second_node.key.must_equal "box2"
  #   third_node = second_node.out.first
  #   third_node.key.must_equal "box3"
  #   fourth_node = third_node.out.first
  #   fourth_node.key.must_equal "box4"    
  # end

  it "can connect a box" do
    box1 = mock_box(id: "box1", d_in: :poo, d_out: :bar)
    box2 = mock_box(id: "box2", d_in: :baz, d_out: :pah)
    n1 = Network.from_box(box1)
    n = n1 >~ box2
    n.first_node.key.must_equal "box1"
    n.first_node.out.first.key.must_equal "box2"
    n.last_node.key.must_equal "box2"
    connection = n.first_node.out_edges.first
    connection.wont_be_nil
    connection.properties[:outlet].must_equal :bar
    connection.properties[:inlet].must_equal :baz
    n.inlet.must_equal :poo
    n.outlet.must_equal :pah
  end
    
  it "can connect an array" do
    box1 = mock_box(id: "box1", d_in: :poo, d_out: :bar)
    box2 = mock_box(id: "box2", h_in: :box2in, h_out: :box2out)
    n1 = Network.from_box(box1)
    n = n1 >~ [:box2in, box2, :box2out]
    n.first_node.key.must_equal "box1"
    n.first_node.out.first.key.must_equal "box2"
    n.last_node.key.must_equal "box2"
    connection = n.first_node.out_edges.first
    connection.wont_be_nil
    connection.properties[:outlet].must_equal :bar
    connection.properties[:inlet].must_equal :box2in
    n.inlet.must_equal :poo
    n.outlet.must_equal :box2out
  end

  it "can connect a string which is turned into a PdBox" do
    box = mock_box(id: "box1", d_out: :bar)
    n = Network.from_box(box)
    n >~ "faz"
    n.first_node.key.must_equal "box1"
    pdb = n.first_node.out.first.properties[:box]
    pdb.must_be_instance_of PdBox
    pdb.pd_object.must_equal "faz"
  end

end