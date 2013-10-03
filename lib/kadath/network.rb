require 'turbine'
require 'superators19'

module Kadath

  class Network

    attr_reader :graph

    def initialize(box)
      @graph = Turbine::Graph.new
      @graph.add(Turbine::Node.new(box.id, box: box))
      @out = box.default_out
      @in = box.default_in
    end

    # If invoked without a name, returns the currently selected
    # out of the out box.
    # If invoked with a name, sets the currently selected out of
    # the out box and returns the network for chaining.
    def out(name = nil)
      if !name
        @out
      elsif out_box.has_out?(name)
        @out = name
        self
      else
        fail "#{out_box.class.name} does not have an out with name #{name}"
      end
    end

    # If invoked without a name, returns the currently selected
    # in of the in box.
    # If invoked with a name, sets the currently selected in of
    # the in box and returns the network for chaining.
    def in(name = nil)
      if !name
        @in
      elsif in_box.has_in?(name)
        @in = name
        self
      else
        fail "#{out_box.class.name} does not have an in with name #{name}"
      end
    end

    # Merge another network with this one, attaching the out of
    # this network to the in of the merged network, and then return
    # this network for chaining.
    # Raises an error if either of the required connection points
    # are nil.
    def append(network)
      fail "Network does not have an out to connect to the network being attached" if !@out
      fail "Network being attached does not have an in to connect this network to" if !network.in
      out_node.connect_to(
        network.in_node,
        nil, 
        out: @out,
        in: network.in
      )
      network.graph.nodes.each { |n| @graph.add(n) }
      self
    end
    alias_method :<<, :append

    superator ">~" do |operand|
      self.append(operand)
    end

    # The node containing the currently selected in box.
    def in_node
      @graph.nodes.first
    end

    private

    def out_node
      @graph.nodes.last
    end

    def in_box
      in_node.properties[:box]
    end

    def out_box
      out_node.properties[:box]
    end

  end

end