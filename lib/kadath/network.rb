require 'turbine'

require_relative 'wire_to_operator'
require_relative 'boxes/pd'

module Kadath
  class Network

    include WireToOperator

    attr_reader :graph

    class << self

      def from_box(box)
        from_box_with_connectors(box, nil, nil)
      end

      # Array must be in format:
      # [inlet, bon, outlet]
      # [inlet, bon]
      # [bon, outlet]
      # [bon] <- stupid but possible
      # where bon is a box or network
      #
      # TODO make this code less shit
      def from_array(arr)
        inlet = nil
        outlet = nil
        case arr.length
        when 1
          bon = arr.first
        when 2
          if arr.first.is_a?(Symbol)
            inlet = arr.first
            bon = arr[1]
          else
            bon = arr.first
            outlet = arr[1]
          end
        when 3
          inlet = arr.first
          bon = arr[1]
          outlet = arr[2]
        else
          fail "Appended arrays must have between 1 and 3 items"
        end

        from_bon(bon, inlet, outlet)
      end

    end

    def inlet
      @inlet || first_box.default_inlet
    end

    def outlet
      @outlet || last_box.default_outlet
    end

    # Append a box, string, or array.
    # Attaches the out of this network to the in of the merged network,
    # and then return the new network for chaining.
    def wire_to(thing)
      appended_network =
        if thing.respond_to?(:graph)
          thing
        else
          Network.from_anything(thing)
        end
      Network.merge(self, appended_network)
    end

    def first_node
      @graph.nodes.first
    end

    def first_box
      first_node.properties[:box]
    end

    def last_node
      @graph.nodes.last
    end

    def last_box
      last_node.properties[:box]
    end

    def each_box
      @graph.nodes.each { |node| yield(node.properties[:box]) }
    end

    def each_connection
      @graph.nodes.each do |node|
        node.out_edges.each do |out_edge|
          yield(
            out_edge.from.properties[:box],
            out_edge.properties[:outlet],
            out_edge.to.properties[:box],
            out_edge.properties[:inlet]
          )
        end
      end
    end

    private

    class << self

      def from_anything(thing)
        if thing.respond_to?(:each)
          from_array(thing)
        else
          from_bon(thing)
        end
      end

      # BON stands for Box Or Network
      def from_bon(bon, inlet = nil, outlet = nil)
        if bon.respond_to?(:graph)
          from_network_with_connectors(bon, inlet, outlet)
        elsif bon.respond_to?(:id)
          from_box_with_connectors(bon, inlet, outlet)
        else
          fail "Cannot create network from #{bon.class.name}"
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

      def from_graph_with_connectors(graph, inlet, outlet)
        Network.new(graph: graph, inlet: inlet, outlet: outlet)        
      end

      def merge(network_1, network_2)
        if !network_1.outlet
          fail "Network does not have an out to connect to the network being attached"
        end
        if !network_2.inlet
          fail "Network being attached does not have an in to connect this network to"
        end

        network_1.last_node.connect_to(
          network_2.first_node,
          nil,
          outlet: network_1.outlet,
          inlet: network_2.inlet
        )

        graph = Turbine::Graph.new
        (network_1.graph.nodes + network_2.graph.nodes).each do |node|
          graph.add(node)
        end
        from_graph_with_connectors(graph, network_1.inlet, network_2.outlet)
      end

    end

    def initialize(options = {})
      @graph = options[:graph]
      @outlet = options[:outlet]
      @inlet = options[:inlet]
      
      unless @graph && @graph.nodes.length > 0
        fail "Network graph must contain at least 1 node"
      end

      @inlet = nil if @inlet == first_box.default_inlet
      if @inlet && !first_box.has_inlet?(@inlet)
        fail "#{first_box.class.name} does not have an inlet with name #{@inlet}"
      end

      @outlet = nil if @outlet == last_box.default_outlet
      if @outlet && !last_box.has_outlet?(@outlet)
        fail "#{last_box.class.name} does not have an outlet with name #{@outlet}"
      end
    end

  end
end