require 'spec_helper'

module Sdos
  describe TweetParser do
    describe 'TweetParser.parse_tweet' do
      it 'should properly parse author and mentioned user' do
        input = 'alberta: hey @christie. what will we be reading at the book club meeting tonight?'
        result = TweetParser.parse_tweet(input)

        result[:author].should == 'alberta'
        result[:mentioned].should == %w(christie)
      end
      it 'should parse tweet #2' do
        input = 'christie: "Every day, men and women, conversing, beholding and beholden..." /cc @alberta, @bob'
        result = TweetParser.parse_tweet(input)

        result[:author].should == 'christie'
        result[:mentioned].should == %w(alberta bob)
      end
    end
  end
end
