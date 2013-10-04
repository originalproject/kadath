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
      # box = options[:box]
      # if box 
      #   @graph.add(Turbine::Node.new(box.id, box: box))
      #   # Skip the has_out?/in? test when using box defaults
      #   if options[:out]
      #     self.out = options[:out]
      #   else
      #     @out = box.default_out
      #   end
      #   if options[:in]
      #     self.in = options[:in]
      #   else
      #     @in = box.default_in
      #   end
      # end
    end

    # If invoked without a name, returns the currently selected
    # out of the out box.
    # If invoked with a name, sets the currently selected out of
    # the out box and returns the network for chaining.
    def out(name = nil)
      if !name
        @out
      else
        self.out = name
        self
      end
    end

    # Sets the currently selected out of the out box
    def out=(name)
      if out_box.has_out?(name)
        @out = name
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
      else
        self.in = name
        self
      end
    end

    # Sets the currently selected in of the in box
    def in=(name)
      if in_box.has_in?(name)
        @in = name
      else
        fail "#{out_box.class.name} does not have an in with name #{name}"
      end
    end

    # Append a box or network,
    # or array containing a box/network & specified ins/outs,
    # attaching the out of this network to the in of the merged network,
    # and then return this network for chaining.
    # Raises an error if either of the required connection points
    # are nil.
    def append(thing)
      if is_array?(thing)
        append_array(thing)
      else
        append_network_or_box(thing)
      end
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

    def append_network_or_box(thing, i = nil, o = nil)
      if is_network?(thing)
        append_network(thing, i, o)
      elsif is_box?(thing)
        append_box(thing, i, o)
      else
        fail "Cannot add #{thing.class.name} to network"
      end
    end

    # Appended arrays should be in formats:
    # [in, box, out]
    # [in, box]
    # [box, out]
    # [box] <- stupid but possible
    #
    # TODO make this code less shit
    def append_array(arr)
      i = nil
      o = nil
      case arr.length
      when 0
        return
      when 1
        thing = arr.first
      when 2
        if(is_network?(arr.first) || is_box?(arr.first))
          thing = arr.first
          o = arr[1]
        else
          i = arr.first
          thing = arr[1]
        end
      when 3
        i = arr.first
        thing = arr[1]
        o = arr[2]
      else
        fail "Appended arrays must have between 1 and 3 items"
      end
      append_network_or_box(thing, i, o)
    end

    def append_network(network, i = nil, o = nil)
      # TODO do this on a clone of the appended network
      # as this is changing the original networks ins & outs
      fail "Network does not have an out to connect to the network being attached" if !@out
      network.in = i if i
      fail "Network being attached does not have an in to connect this network to" if !network.in
      network.out = o if o
      out_node.connect_to(
        network.in_node,
        nil, 
        out: @out,
        in: network.in
      )
      network.graph.nodes.each { |n| @graph.add(n) }
    end

    def append_box(box, i = nil, o = nil)
      append_network(Network.new(box), i, o)
    end

    def is_network?(thing)
      thing.respond_to?(:in_node)
    end

    def is_array?(thing)
      thing.respond_to?(:each)
    end

    def is_box?(thing)
      thing.respond_to?(:default_in)
    end

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