require_relative 'kadath/monkeypatches/string'
require_relative 'kadath/pd/pd_renderer'
require_relative 'kadath/audio'
require_relative 'kadath/pd/jrpd_connector'
# require_relative 'kadath/network'
# require_relative 'kadath/pd/box'
# require_relative 'kadath/renderable'
# require_relative 'kadath/version'
# require_relative 'kadath/wire_to_operator'

module Kadath

  extend SingleForwardable

  def_delegators :renderer, :render

  def_delegator :audio, :start, :start_audio

  def_delegator :audio, :stop, :stop_audio

  def self.gem_root
    @gem_root ||= Gem::Specification.find_by_name("kadath").gem_dir
  end

  private

  def self.renderer
    @renderer ||= PdRenderer.new(connector)
  end

  def self.audio
    @audio ||= Audio.new(connector)
  end

  def self.connector
    @connector ||= JRPDConnector.new
  end

end