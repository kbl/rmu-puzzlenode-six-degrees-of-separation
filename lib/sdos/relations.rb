module Sdos
  class Relations

    def initialize(parser)
      @tweets = []

      parser.parse do |tweet|
        self.<<(tweet)
      end
    end

    def [](name)
      []
    end

    protected 

    def <<(tweet)
      @tweets << tweet
    end
  end
end
