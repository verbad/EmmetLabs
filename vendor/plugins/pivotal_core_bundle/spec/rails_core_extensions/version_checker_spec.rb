dir = File. dirname(__FILE__)
require "#{dir}/../spec_helper"

describe Pivotal::VersionChecker do
  it "should correctly check versions" do
    Pivotal::VersionChecker.should be_version_matches('0.11.0','> 0.9.0') # not string comparison
    Pivotal::VersionChecker.should be_version_matches('1.2.3','=1.2.3') # no spaces are OK
    Pivotal::VersionChecker.should be_version_matches('1.2.3','~> 1.2') # "Pessimistic version constraint"
  end

end