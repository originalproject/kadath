module Kadath
  class PdRenderer

    def initialize(pd_connector = nil)
      @connector = pd_connector
    end

    def render(network)
      fail("Cannot render to Pd without a Pd connector") unless connector
      yield_objects_and_connections(network) do |s|
        connector.send_to_patch(s)
      end
    end

    def render_to_file(network, filename)
      File.open(filename, "w") do |f|
        f.puts '#N canvas 0 0 400 800 10;'
        yield_objects_and_connections(network) do |s|
          f.puts "#X #{s};"
        end
      end
    end

    private

    Y_SPACING = 32

    attr_reader :connector

    def yield_objects_and_connections(network, &block)
      yield_objects(network, &block)
      yield_connections(network, &block)
    end

    def yield_objects(network, &block)
      network.each_box { |pd_box| yield_object(pd_box, &block) }
    end

    def yield_object(pd_box)
      return unless (index = register_box(pd_box))
      yield "obj 0 #{ index * Y_SPACING } #{ pd_box.pd_object }"
    end

    def box_index(pd_box)
      box_registry[pd_box.object_id]
    end

    def register_box(pd_box)
      key = pd_box.object_id
      if box_registry.has_key?(key)
        nil
      else
        box_registry[key] = take_registry_index!
      end
    end

    def box_registry
      @box_registry ||= {}
    end

    def take_registry_index!
      @registry_index = (@registry_index || -1) + 1
    end

    def yield_connections(network, &block)
      network.each_connection do |from_pd_box, from_outlet, to_pd_box, to_inlet|
        yield_connection(from_pd_box, from_outlet, to_pd_box, to_inlet, &block)
      end
    end

    def yield_connection(from_pd_box, from_outlet, to_pd_box, to_inlet)
      from_index = box_index(from_pd_box)
      to_index = box_index(to_pd_box)
      fail "Cannot connect unrendered boxes" unless from_index && to_index
      return unless register_connection(from_index, from_outlet, to_index, to_inlet)
      yield "connect #{ from_index } #{ from_outlet } #{ to_index } #{ to_inlet }"
    end

    def register_connection(from_index, from_outlet, to_index, to_inlet)
      path = "#{ from_index }/#{ from_outlet }/#{ to_index }/#{ to_inlet }"
      if connection_registry.include?(path)
        false
      else
        connection_registry << path
        true
      end
    end

    def connection_registry
      @connection_registry ||= Set.new
    end

  end
end