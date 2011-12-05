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
      it 'should trim whitesigns from author' do
        input = '  madelyn: It began with Henry VII'
        tweet = TweetParser.parse_tweet(input)

        tweet.author.should == 'madelyn'
        tweet.mentioned.should be_empty
      end
    end
    describe 'TweetParser#parse' do
      it 'should be possible to parse file line by line' do
        input = StringIO.new <<-EOS
          emily: Ain't that the truth /cc @christie
          duncan: hey @farid, can you pick up some of those cookies on your way home?
          farid: @duncan, might have to work late tonight, but I'll try
        EOS
        parser = TweetParser.new(input)

        tweets = []
        parser.parse do |tweet|
          tweets << tweet
        end

        tweets.should_not be_empty
        p tweets
      end
    end
  end
end
