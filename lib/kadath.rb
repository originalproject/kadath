require_relative 'kadath/audio'
require_relative 'kadath/inventory'
require_relative 'kadath/pd/renderer'
require_relative 'kadath/pd/jrpd_connector'

module Kadath

  extend SingleForwardable

  def_delegator :audio, :start, :start_audio

  def_delegator :audio, :stop, :stop_audio

  def self.gem_root
    @gem_root ||= Gem::Specification.find_by_name("kadath").gem_dir
  end

  def self.render(network = nil, &block)
    if block
      network = inventory.instance_eval(&block)
    end
    renderer.render(network)
  end

  private

  def self.renderer
    @renderer ||= Pd::Renderer.new(connector)
  end

  def self.audio
    @audio ||= Audio.new(connector)
  end

  def self.connector
    @connector ||= Pd::JRPDConnector.new
  end

  def self.inventory
    @inventory ||= Inventory.new
  end

end