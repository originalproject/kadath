# require_relative 'kadath/monkeypatches/string'
# require_relative 'kadath/network'
# require_relative 'kadath/pd_box'
# require_relative 'kadath/renderable'
# require_relative 'kadath/version'
# require_relative 'kadath/wire_to_operator'

module Kadath

  attr_writer :renderer

  def self.renderer
    @renderer ||=
      if true
        # REVIEW Is this bad? I don't want to require the default renderer
        # at the top of the file if it's never actually going to be used
        require_relative 'kadath/pd_renderer'
        PdRenderer.new
      end
  end

  def self.render(network)
    renderer.render(network)
  end

end
