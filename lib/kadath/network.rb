require 'turbine'

module Kadath

  class Network

    attr_reader :graph

    def initialize(box)
      @graph = Turbine::Graph.new
      @graph.add(Turbine::Node.new(box.id, box: box))
      @out = box.default_out
      @in = box.default_in
    end

    def current_in
      @in
    end

    def current_out
      @out
    end

    def out(name)
      if exit_box.has_out?(name)
        @out = name
        return self
      else
        fail "Exit box does not have an out with name #{name}"
      end
    end

    def in(name)
      if entry_box.has_in?(name)
        @in = name
        return self
      else
        fail "Entry box does not have an in with name #{name}"
      end
    end

    def <<(network)
      if @out && network.current_in
        exit_node.connect_to(
          network.entry_node,
          nil, 
          out: @out, 
          in: network.current_in
        )
      end # TODO else exception
    end

    def entry_node
      @graph.nodes.first
    end

    private

    def exit_node
      @graph.nodes.last
    end

    def entry_box
      entry_node.properties[:box]
    end

    def exit_box
      exit_node.properties[:box]
    end

=begin
    def nodify(box)
      name = box.class.name
      Tree::TreeNode.new(name, box)
      box.responds_to?(:in) && box.in.each do |in_name|
        Tree::TreeNode.new("In #{in_name}") << node
      end
      box.responds_to?(:out) && box.out.each do |out_name|
        node << Tree::TreeNode.new("Out #{out_name}")
      end
    end
=end

  end

end