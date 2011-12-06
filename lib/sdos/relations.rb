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
      @name = name
      initialize_visited_unvisited
      vertex = @name

      until @unvisited.empty? do
        vertex_cost = @visited[vertex]
        adjacent = self.[](vertex)
        adjacent_unvisited = adjacent & @unvisited

        adjacent_unvisited.each do |adjacent_vertex|
          adjacent_cost = @visited[adjacent_vertex] 
          new_path_cost = vertex_cost + 1
          if adjacent_cost.nil?
            @visited[adjacent_vertex] = new_path_cost
          elsif adjacent_cost > new_path_cost
            @visited[adjacent_vertex] = new_path_cost
          end
        end

        @unvisited.delete(vertex)
        @unvisited.sort do |a, b| 
          result = @visited[a] <=> @visited[b]
          result || -1
        end
        vertex = @unvisited.shift
      end

      @visited.delete(name)
      @visited
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

    def initialize_visited_unvisited
      @visited = {}
      @visited[@name] = 0

      @unvisited = @relation_graph.to_a
      @unvisited.delete(@name)
      @unvisited.each { |v| @visited[v] = nil }
      @unvisited.unshift(@name)
    end

  end
end
