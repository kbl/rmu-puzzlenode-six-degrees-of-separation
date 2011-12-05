module Sdos
  class Tweet

    attr_reader :author, :mentioned

    def initialize(author, mentioned)
      @author, @mentioned = author, Set.new(mentioned)
    end

    def to_s
      "#{@author}: #{@mentioned.to_a}"
    end

  end
end
