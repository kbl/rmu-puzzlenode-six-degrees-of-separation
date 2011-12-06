module Sdos
  module Graph
    module Utils

      def reverse_map(map)
        reversed = {}
        map.each do |key, value|
          array = reversed[value] || reversed[value] = []
          array << key
        end

        reversed
      end

    end
  end
end
