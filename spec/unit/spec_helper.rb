require_relative '../spec_helper.rb'
#require 'mocha/setup'
require 'rr'

include Kadath

def publicize_class(klass)
  klass.class_eval do
    @ooh_me_privates = self.private_instance_methods
    public *@ooh_me_privates
  end
end

def unpublicize_class(klass)
  klass.class_eval do
    private *@ooh_me_privates
  end
end