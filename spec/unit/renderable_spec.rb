require 'kadath/renderable'
require_relative 'spec_helper'

class Harness
  include Renderable

  def rendered?
    @rendered ||= false
  end

  private

  def rendered=(rendered)
    @rendered = rendered
  end

end

describe Renderable do

  it "has a render method which renders the extended object and sets rendered? true" do
    h = Harness.new
    h.render
    h.rendered?.must_equal true
  end

  it "has a render_connection_to method which connects the current out to the given network's in" do
    h = Harness.new
    h.render_connection_to("foo")
  end

end