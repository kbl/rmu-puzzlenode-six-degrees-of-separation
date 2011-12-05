require 'sdos/tweet'

module Sdos
  class TweetParser

    AUTHOR_SEPARATOR = ':'
    USER_PATTERN = /@(\w*)/

    class << self
      def parse_tweet(tweet)
        mentioned = []
        author, tweet_body = tweet.split(AUTHOR_SEPARATOR)

        while(match_data = USER_PATTERN.match(tweet_body)) 
          mentioned << $1
          tweet_body = match_data.post_match
        end

        Tweet.new(author, mentioned)
      end
    end

  end
end
