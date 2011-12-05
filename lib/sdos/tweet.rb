module Sdos
  class Tweet

    attr_reader :author, :mentioned

    def initialize(author, mentioned)
      @author, @mentioned = author, Set.new(mentioned)
    end

  end
end
