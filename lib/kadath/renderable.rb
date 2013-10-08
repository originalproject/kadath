module Kadath
  module Renderable

    def render
      # TODO validate not rendered
      self.rendered = true
    end

    def render_connection_to(other)
      # TODO validate self & other rendered
    end

  end
end