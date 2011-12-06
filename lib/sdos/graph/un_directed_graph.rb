require 'rgl/adjacency'
require 'rgl/connected_components'
require 'rgl/dot'

module Sdos
  module Graph
    class UnDirectedGraph

      def initialize
        @graph = RGL::DirectedAdjacencyGraph.new
      end

      def <<(tweet)
        a = tweet.author

        @graph.add_vertex(a)
        tweet.mentioned.each do |mentioned|
          @graph.add_edge(a, mentioned)
        end
      end
      
      def strongly_connected_components!
        visitor = RGL::Graph::TarjanSccVisitor.new(@graph)
        @graph.depth_first_search(visitor) { |v| }

        comp_map = reverse_map(visitor.comp_map)
        lonely_vertices = comp_map.select { |index, array| array.size < 2 }.map { |i, a| a }.flatten

        lonely_vertices.each { |v| @graph.remove_vertex(v) }
        remove_unidirectional_edges
        @graph = @graph.to_undirected
      end

      def to_a
        @graph.to_a
      end

      def adjacent_vertices(vertex)
        @graph.adjacent_vertices(vertex)
      end

      private
      
      def remove_unidirectional_edges
        unidirectional_edges = @graph.edges
        @graph.edges.each do |edge|
          reversed = edge.reverse
          if unidirectional_edges.include?(reversed)
            unidirectional_edges.delete(edge)
            unidirectional_edges.delete(reversed)
          end
        end
        unidirectional_edges.each { |e| @graph.remove_edge(*e.to_a) }
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
end
