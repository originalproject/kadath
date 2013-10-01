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
      end # else exception
    end

    def in(name)
      if entry_box.has_in?(name)
        @in = name
      end # else exception
    end

    private

    def entry_box
      @graph.nodes.first.properties[:box]
    end

    def exit_box
      @graph.nodes.last.properties[:box]
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