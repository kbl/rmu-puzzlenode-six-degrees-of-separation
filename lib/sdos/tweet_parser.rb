module Sdos
  class TweetParser
 
    TWEET_PATTERN = /(\w*):.*?@(\w*)/

    class << self
      def parse_tweet(tweet)
        x = {}
        match_data = TWEET_PATTERN.match(tweet)
        x[:author] = match_data[1]
        x[:mentioned] = match_data.to_a.slice(2..-1)

        x
      end
    end

  end
end
