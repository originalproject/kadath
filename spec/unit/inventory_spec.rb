require 'kadath/inventory'
require_relative 'spec_helper'

describe Inventory do

  before do
    @inv = Inventory.new
  end

  it "has a pd method which creates a new Pd box with the passed argument" do
    stub(Boxes::Pd).new { 'potato' }
    pd = @inv.pd('foo')
    pd.must_equal 'potato'
    assert_received(Boxes::Pd) { |p| p.new('foo') }
  end

end