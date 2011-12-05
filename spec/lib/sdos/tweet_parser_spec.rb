require 'spec_helper'

module Sdos
  describe TweetParser do
    describe 'TweetParser.parse_tweet' do
      it 'should properly parse author and mentioned user' do
        input = 'alberta: hey @christie. what will we be reading at the book club meeting tonight?'
        tweet = TweetParser.parse_tweet(input)

        tweet.author.should == 'alberta'
        tweet.mentioned.should contain(%w(christie))
      end
      it 'should parse tweet #2' do
        input = 'christie: "Every day, men and women, conversing, beholding and beholden..." /cc @alberta, @bob'
        tweet = TweetParser.parse_tweet(input)

        tweet.author.should == 'christie'
        tweet.mentioned.should contain(%w(alberta bob))
      end
      it 'should mention every user only once' do
        input = 'madelyn: @bob It @nella_hackett began with Henry VII /cc @nella_hackett'
        tweet = TweetParser.parse_tweet(input)

        tweet.author.should == 'madelyn'
        tweet.mentioned.should contain(%w(bob nella_hackett))
      end
    end
  end
end
