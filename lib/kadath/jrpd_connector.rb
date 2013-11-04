require 'jrpd'

module Kadath
  class JRPDConnector

    KADATH_PD_FILE_PATH = (
      Pathname.new(__FILE__).parent.parent.parent + "data" + "kadath.pd"
    ).to_s

    def initialize
      @patch = JRPD::Patch.new(KADATH_PD_FILE_PATH)
    end

    def send_to_patch(unstructured_msg)
      @patch.send_unstructured_message(unstructured_msg)
    end

  end
end