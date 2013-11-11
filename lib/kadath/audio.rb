module Kadath
  class Audio

    extend Forwardable

    def_delegator :@connector, :start_audio, :start

    def_delegator :@connector, :stop_audio, :stop

    def initialize(pd_connector)
      @connector = pd_connector
    end

  end
end