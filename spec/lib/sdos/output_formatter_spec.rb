require 'spec_helper'

module Sdos
  describe OutputFormatter do
    it 'should format output in alphabetical order' do
      output = ''
      File.open(path('sample_output.txt')) do |file|
        file.each { |line| output << line }
      end

      File.open(path('sample_input.txt')) do |file|
        relations = Relations.new(TweetParser.new(file))
        stream = StringIO.new

        OutputFormatter.format(relations.relations, stream)
        stream.string.should == output
      end
    end
    it 'should pass puzzlenode (:' do
      File.open(path('complex_input.txt')) do |file|
        relations = Relations.new(TweetParser.new(file))
        file = File.new('complex_output.txt', 'w')
        OutputFormatter.format(relations.relations, file)
        file.close
      end
    end
  end
end
