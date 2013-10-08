require 'turbine'
require_relative 'network'

module Kadath
  module NetworkFactories

    def network_from_box(box)
      graph = Turbine::Graph.new
      graph.add(Turbine::Node.new(box.id, box: box))
      Network.new(graph: graph)
    end

  end
end