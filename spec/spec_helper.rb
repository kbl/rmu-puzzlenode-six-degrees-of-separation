require 'rspec'
require 'stringio'
require 'sdos/tweet_parser'
require 'sdos/tweet'

RSpec::Matchers.define :contain do |array|
  match do |set|
    set.to_a.should == array
  end
end
