require 'rgl/adjacency'
require 'rgl/connected_components'

module Sdos
  class Relations

    include RGL

    def initialize(parser)
      @relation_graph = DirectedAdjacencyGraph.new

      parser.parse do |tweet|
        self.<<(tweet)
      end

      keep_only_bidirectional_relations
    end

    def [](name)
      @relation_graph.adjacent_vertices(name)
    end

    protected

    def <<(tweet)
      a = tweet.author

      @relation_graph.add_vertex(a)
      tweet.mentioned.each do |mentioned|
        @relation_graph.add_edge(a, mentioned)
      end
    end

    private

    def keep_only_bidirectional_relations
      visitor = Graph::TarjanSccVisitor.new(@relation_graph)
      @relation_graph.depth_first_search(visitor) { |v| }

      comp_map = reverse_map(visitor.comp_map)
      lonely_vertices = comp_map.select { |index, array| array.size < 2 }.map { |i, a| a }.flatten

      lonely_vertices.each { |v| @relation_graph.remove_vertex(v) }
    end

    def reverse_map(map)
      reversed = {}
      map.each do |vertex, index|
        array = reversed[index] || reversed[index] = []
        array << vertex
      end

      reversed
    end
  end
end
