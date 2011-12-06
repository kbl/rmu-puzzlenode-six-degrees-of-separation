module Sdos
  class OutputFormatter

    def self.format(all_relations, stream)
      all_relations.each do |name, relations|
        stream.puts(name)
        relations.each do |level, friends|
          stream.puts(friends.join(', '))
        end
        stream.puts
      end
    end

  end
end
