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

    def friends(name)
      visited, unvisited = initialize_visited_unvisited(name)

      unvisited.each do |vertex|
        vertex_cost = visited[vertex]
        adjacent_vertices = self.[](vertex)

        adjacent_vertices.each do |adjacent|
          adjacent_cost = visited[adjacent] 
          if adjacent_cost == 0
            visited[adjacent] = 1
          else

          end
        end
      end

      visited
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
      @relation_graph = @relation_graph.to_undirected
    end

    def reverse_map(map)
      reversed = {}
      map.each do |vertex, index|
        array = reversed[index] || reversed[index] = []
        array << vertex
      end

      reversed
    end

    def initialize_visited_unvisited(name)
      visited = {}

      unvisited = @relation_graph.to_a
      unvisited.delete(name)
      unvisited.each { |v| visited[v] = 0 }
      unvisited.unshift(name)

      [visited, unvisited]
    end

  end
end
