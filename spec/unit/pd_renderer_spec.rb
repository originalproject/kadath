require 'kadath/pd/pd_renderer'
require_relative 'spec_helper'

def stub_network
  box1 = stub(pd_object: "foo")
  box2 = stub(pd_object: "bar")
  network = stub
  network
    .stubs(:each_box)
    .multiple_yields(
      box1,
      box2
    )
  network
    .stubs(:each_connection)
    .multiple_yields(
      [box1, 0, box2, 0],
      [box1, 0, box2, 1],
      [box1, 1, box2, 0],
      [box1, 1, box2, 1]
    )
  network
end

describe PdRenderer do

  before do
    publicize_class(PdRenderer)
  end

  after do
    unpublicize_class(PdRenderer)
  end

  it "can render a network to a pd file" do
    # Can't be bothered to do a rewrite now but a better strategy for
    # testing file IO is to use fakefs https://github.com/defunkt/fakefs
    
    file = mock
    writes = sequence("writes")
    file.expects(:puts).with("#N canvas 0 0 400 800 10;").in_sequence(writes)
    file.expects(:puts).with("#X obj 0 0 foo;").in_sequence(writes)
    file.expects(:puts).with("#X obj 0 32 bar;").in_sequence(writes)
    file.expects(:puts).with("#X connect 0 0 1 0;").in_sequence(writes)
    file.expects(:puts).with("#X connect 0 0 1 1;").in_sequence(writes)
    file.expects(:puts).with("#X connect 0 1 1 0;").in_sequence(writes)
    file.expects(:puts).with("#X connect 0 1 1 1;").in_sequence(writes)

    File.expects(:open).with("foo.pd", "w").yields(file)

    pdr = PdRenderer.new
    pdr.render_to_file(stub_network, "foo.pd")
  end

  it "can be initialized with a Pd connector" do
    pdr = PdRenderer.new('foo')
    pdr.connector.must_equal 'foo'
  end

  it "can be initialized without a Pd connector" do
    pdr = PdRenderer.new
  end

  it "can render a network to its Pd connector" do
    pdc = mock
    msgs = sequence("msgs")
    pdc.expects(:send_to_patch).with("obj 0 0 foo").in_sequence(msgs)
    pdc.expects(:send_to_patch).with("obj 0 32 bar").in_sequence(msgs)
    pdc.expects(:send_to_patch).with("connect 0 0 1 0").in_sequence(msgs)
    pdc.expects(:send_to_patch).with("connect 0 0 1 1").in_sequence(msgs)
    pdc.expects(:send_to_patch).with("connect 0 1 1 0").in_sequence(msgs)
    pdc.expects(:send_to_patch).with("connect 0 1 1 1").in_sequence(msgs)
    pdr = PdRenderer.new(pdc)
    pdr.render(stub_network)
  end

  it "catches attempts to render to Pd without a connector" do
    pdr = PdRenderer.new
    -> { pdr.render(stub_network) }.must_raise RuntimeError
  end

  # Private method tests. Bite me.

  it "can yield a pd object to a block" do
    box = stub(pd_object: "foo")
    pdr = PdRenderer.new
    output = nil
    pdr.yield_object(box) { |s| output = s }
    output.must_equal "obj 0 0 foo"
  end

  it "yields each pd object at a different y offset" do
    box1 = stub(pd_object: "foo")
    box2 = stub(pd_object: "bar")
    pdr = PdRenderer.new
    output = nil
    pdr.yield_object(box1) {}
    pdr.yield_object(box2) { |s| output = s }
    output.must_equal "obj 0 32 bar"
  end

  it "will not yield the same pd object twice" do
    box = stub(pd_object: "foo")
    pdr = PdRenderer.new
    output = 'never changed'
    pdr.yield_object(box) {}
    pdr.yield_object(box) { |s| output = s }
    output.must_equal 'never changed'
  end

  it "can yield the boxes in a network, one at a time, to a block" do
    network = stub_network
    pdr = PdRenderer.new
    output = []
    pdr.yield_objects(network) { |s| output << s }
    output.must_equal ["obj 0 0 foo", "obj 0 32 bar"]
  end

  it "can yield a pd connection to a block" do
    box1 = stub(pd_object: "foo")
    box2 = stub(pd_object: "bar")
    pdr = PdRenderer.new
    pdr.yield_object(box1) {}
    pdr.yield_object(box2) {}
    output = nil
    pdr.yield_connection(box1, 0, box2, 1) { |s| output = s }
    output.must_equal "connect 0 0 1 1"
  end

  it "yields an error if connection is attempted between unrendered objects" do
    box1 = stub(pd_object: "foo")
    box2 = stub(pd_object: "bar")
    pdr = PdRenderer.new
    pdr.yield_object(box1) {}
    -> { pdr.yield_connection(box1, 0, box2, 1) {} }.must_raise RuntimeError
  end

  it "will not yield the same connection twice" do
    box1 = stub(pd_object: "foo")
    box2 = stub(pd_object: "bar")
    pdr = PdRenderer.new
    pdr.yield_object(box1) {}
    pdr.yield_object(box2) {}
    output = 'never changed'
    pdr.yield_connection(box1, 0, box2, 1) {}
    pdr.yield_connection(box1, 0, box2, 1) { |s| output = s }
    output.must_equal 'never changed'
  end

  it "can yield the connections in a network, one at a time, to a block" do
    network = stub_network
    pdr = PdRenderer.new
    pdr.yield_objects(network) {}
    output = []
    pdr.yield_connections(network) { |s| output << s }
    output.must_equal [
      "connect 0 0 1 0",
      "connect 0 0 1 1",
      "connect 0 1 1 0",
      "connect 0 1 1 1"
    ]
  end

  it "can yield a network, objects then connections, one at a time, to a block" do
    network = stub_network
    output = []
    pdr = PdRenderer.new
    pdr.yield_objects_and_connections(network) { |s| output << s }
    output.must_equal [
      "obj 0 0 foo",
      "obj 0 32 bar",
      "connect 0 0 1 0",
      "connect 0 0 1 1",
      "connect 0 1 1 0",
      "connect 0 1 1 1"
    ]
  end

end