module Sdos
  class OutputFormatter

    def self.format(all_relations, stream)
      first = true
      all_relations.each do |name, relations|
        relations = relations.sort { |(k1, v1), (k2, v2)| k1 <=> k2 }

        unless first
          stream.puts
        end

        stream.puts(name)
        relations.each do |level, friends|
          stream.puts(friends.join(', '))
        end

        first = false
      end
    end

  end
end
