require 'jrpd'

module Kadath
  class JRPDConnector

    def initialize
      pd_file_path = File.join(Kadath.gem_root, 'data/kadath.pd')
      @patch = JRPD::Patch.new(pd_file_path)
    end

    def send_to_patch(unstructured_msg)
      @patch.send_unstructured_message(unstructured_msg)
    end

  end
end