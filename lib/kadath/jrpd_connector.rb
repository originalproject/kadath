require 'jrpd'

module Kadath
  class JRPDConnector

    def send_to_patch(unstructured_msg)
      patch.send_unstructured_message(unstructured_msg)
    end

    def start_audio
      audio.start
    end

    def stop_audio
      audio.stop
    end

    private

    def patch
      @patch ||= open_patch
    end

    def open_patch
      pd_file_path = File.join(Kadath.gem_root, 'data/kadath.pd')
      JRPD::Patch.new(pd_file_path)
    end

    def audio
      @audio ||= JRPD::Audio.new
    end

  end
end