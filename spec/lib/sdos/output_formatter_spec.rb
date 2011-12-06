require 'spec_helper'

module Sdos
  describe OutputFormatter do
    it 'should format output in alphabetical order' do
      File.open(path('sample_output.txt')) do |file|
      end

      File.open(path('sample_input.txt')) do |file|
        relations = Relations.new(TweetParser.new(file))
        stream = StringIO.new

        OutputFormatter.format(relations.relations, stream)
        stream.string.should == ''
      end
    end
  end
end
