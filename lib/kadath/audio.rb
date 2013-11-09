module Kadath
  class Audio

    extend Forwardable

    def_delegators :@connector, :start_audio, :stop_audio

    def initialize(pd_connector)
      @connector = pd_connector
    end

  end
end