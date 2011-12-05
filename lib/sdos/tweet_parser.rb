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

        Tweet.new(author.strip, mentioned)
      end
    end

    def initialize(input)
      @input = input
    end

    def parse(&block)
      @input.each_line do |line|
        yield TweetParser.parse_tweet(line)
      end
    end

  end
end
