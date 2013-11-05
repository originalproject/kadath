require 'minitest/spec'
#require 'minitest/autorun'
# use turn if installed
require 'turn/autorun'
require 'mocha/setup'
include Kadath

Turn.config.format = :progress

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