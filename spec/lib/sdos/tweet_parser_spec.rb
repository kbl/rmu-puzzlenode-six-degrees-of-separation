require 'spec_helper'

module Sdos
  describe TweetParser do
    it 'should properly parse author and mentioned user' do
      input = 'alberta: hey @christie. what will we be reading at the book club meeting tonight?'
      result = TweetParser.parse_tweet(input)

      result[:author].should == 'alberta'
      result[:mentioned].should == %w(christie)
    end
  end
end
