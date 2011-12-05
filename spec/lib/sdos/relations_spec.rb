require 'spec_helper'

module Sdos
  describe Relations do
    it 'should kepp track of bidirectional relations' do
      input = StringIO.new <<-EOS
        emily: Ain't that the truth /cc @duncan
        duncan: hey @emily, can you pick up some of those cookies on your way home?
      EOS
      relations = Relations.new(TweetParser.new(input))

      relations['emily'].should == ['duncan']
      relations['duncan'].should == ['emily']
    end
  end
end
