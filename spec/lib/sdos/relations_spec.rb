require 'spec_helper'

module Sdos
  describe Relations do
    it 'should keep track of bidirectional relations' do
      input = StringIO.new <<-EOS
        emily: Ain't that the truth /cc @duncan
        duncan: hey @emily, can you pick up some of those cookies on your way home?
      EOS
      relations = Relations.new(TweetParser.new(input))

      relations['emily'].should == ['duncan']
      relations['duncan'].should == ['emily']
    end

    it 'shouldnt keep track of unidirectional relations' do
      input = StringIO.new <<-EOS
        christie: @emily, "Books are the best of things, well used; abused, among the worst." -- Emerson
        emily: Ain't that the truth /cc @duncan
        duncan: hey @emily, can you pick up some of those cookies on your way home?
      EOS
      relations = Relations.new(TweetParser.new(input))

      relations['emily'].should == ['duncan']
      relations['christie'].should be_empty
    end
  end
end
