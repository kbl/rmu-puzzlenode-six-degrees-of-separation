require 'spec_helper'

module Sdos
  describe Relations do

    describe 'Relations.[]' do
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
        lambda do
          relations['christie'].should be_empty
        end.should raise_error(RGL::NoVertexError)
      end
    end

    describe 'Relations#friends' do
      it 'should return hash with friends' do
        input = StringIO.new <<-EOS
          a: @b @c
          b: @a
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations.friends('a').should == { 'b' => 1 }
        relations.friends('b').should == { 'a' => 1 }
      end
      it 'should mention transitive friends' do
        input = StringIO.new <<-EOS
          a: @b @c
          b: @a
          c: @a
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations.friends('a').should == { 'b' => 1, 'c' => 1 }
        relations.friends('b').should == { 'a' => 1, 'c' => 2 }
      end
    end

  end
end
