require 'turbine'

require_relative 'wire_to_operator'
require_relative 'pd_box'

module Kadath

  class Network

    include WireToOperator

    attr_reader :graph, :in, :out

    class << self

      def from_box(box)
        from_box_with_connectors(box, nil, nil)
      end

      def from_string(pd_string)
        from_string_with_connectors(pd_string, nil, nil)
      end

      # Array must be in format:
      # [inlet, bson, outlet]
      # [inlet, bson]
      # [bson, outlet]
      # [bson] <- stupid but possible
      # where bson is a box, string or network
      #
      # TODO make this code less shit
      def from_array(arr)
        inlet = nil
        outlet = nil
        case arr.length
        when 1
          bson = arr.first
        when 2
          if arr.first.is_a?(Symbol)
            inlet = arr.first
            bson = arr[1]
          else
            bson = arr.first
            outlet = arr[1]
          end
        when 3
          inlet = arr.first
          bson = arr[1]
          outlet = arr[2]
        else
          fail "Appended arrays must have between 1 and 3 items"
        end

        from_bson_with_connectors(bson, inlet, outlet)
      end

    end

    def initialize(box, options = {})
      @graph = Turbine::Graph.new
      @graph.add(Turbine::Node.new(box.id, box: box))

      @out =
        if (o = options[:out])
          if box.has_out?(o)
            o
          else
            fail "#{out_box.class.name} does not have an out with name #{name}"
          end
        else
          box.default_out
        end

      @in =
        if (i = options[:in])
          if box.has_in?(i)
            i
          else
           fail "#{out_box.class.name} does not have an in with name #{name}"
          end
        else
          box.default_in
        end

      #@out = box.default_out
      #@in = box.default_in
    end

=begin
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
=end

    # Append a box or network,
    # or array containing a box/network & specified ins/outs,
    # attaching the out of this network to the in of the merged network,
    # and then return this network for chaining.
    # Raises an error if either of the required connection points
    # are nil.
    def wire_to(thing)
      if is_array?(thing)
        append_array(thing)
      else
        append_thing(thing)
      end
      self
    end
    alias_method :<<, :wire_to
    alias_method :append, :wire_to

    # The node containing the currently selected in box.
    def in_node
      @graph.nodes.first
    end

    private

    class << self

      # BSON stands for Box String Or Network
      def from_bson_with_connectors(bson, inlet, outlet)
        if bson.is_a?(String)
          from_string_with_connectors(bson, inlet, outlet)
        elsif bson.respond_to?(:graph)
          from_network_with_connectors(bson, inlet, outlet)
        elsif bson.respond_to?(:id)
          from_box_with_connectors(bson, inlet, outlet)
        else
          fail "Cannot create network from #{bson.class.name}"
        end
      end

      def from_network_with_connectors(network, inlet, outlet)
        from_graph_with_connectors(network.graph, inlet, outlet)
      end

      def from_box_with_connectors(box, inlet, outlet)
        graph = Turbine::Graph.new
        graph.add(Turbine::Node.new(box.id, box: box))
        from_graph_with_connectors(graph, inlet, outlet)
      end

      def from_string_with_connectors(pd_string, inlet, outlet)
        pd_box = PdBox.new(pd_string)
        from_box_with_connectors(pd_box, inlet, outlet)
      end

      def from_graph_with_connectors(graph, inlet, outlet)
        Network.new(graph: graph, inlet: inlet, outlet: outlet)        
      end

    end

    def append_thing(thing, i = nil, o = nil)
      if is_network?(thing)
        append_network(thing, i, o)
      elsif is_box?(thing)
        append_box(thing, i, o)
      elsif thing.is_a?(String)
        append_string(thing, i, o)
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
      append_thing(thing, i, o)
    end

    def append_network(network, i = nil, o = nil)
      # TODO do this on a clone of the appended network
      # as this is changing the original network's ins & outs
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
      # if graph.nodes.empty?
      #   # yuck
      #   @in = network.in
      #   @out = network.out
      # else
      #   fail "Network does not have an out to connect to the network being attached" if !@out
      #   fail "Network being attached does not have an in to connect this network to" if !network.in
      #   out_node.connect_to(
      #     network.in_node,
      #     nil, 
      #     out: @out,
      #     in: network.in
      #   )
      # end
      network.graph.nodes.each { |n| @graph.add(n) }
    end

    def append_box(box, i = nil, o = nil)
      append_network(Network.new(box), i, o)
    end

    def append_string(s, i = nil, o = nil)
      append_box(PdBox.new(s), i, o)
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