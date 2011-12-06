require 'rspec'
require 'stringio'
require 'sdos/tweet_parser'
require 'sdos/tweet'
require 'sdos/relations'
require 'sdos/output_formatter'


def path(filename)
   File.join(File.dirname(__FILE__), filename)
end

RSpec::Matchers.define :contain do |array|
  match do |set|
    set.to_a.should == array
  end
end
