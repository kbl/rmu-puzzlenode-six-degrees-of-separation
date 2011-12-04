module Sdos
  class TweetParser

    TWEET_PATTERN = /([a-z]*):.*?(@([a-z]*).*?)*/i

    class << self
      def parse_tweet(tweet)
        x = {}
        match_data = TWEET_PATTERN.match(tweet)
        p match_data
        x[:author] = match_data[1]
        x[:mentioned] = match_data.to_a.slice(2..-1)

        x
      end
    end

  end
end
