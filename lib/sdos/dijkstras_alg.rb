module Sdos
  class DijkstrasAlg

    def initialize(graph, name)
      @graph = graph
      @name = name
    end

    def find_shortest_paths
      initialize_visited_unvisited
      vertex = @name

      until @unvisited.empty? do
        vertex_cost = @visited[vertex]

        adjacent_and_unvisited(vertex).each do |adjacent_vertex|
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

      @visited.delete(@name)
      @visited
    end

    private

    def initialize_visited_unvisited
      @visited = {}
      @visited[@name] = 0

      @unvisited = @graph.to_a
      @unvisited.delete(@name)
      @unvisited.each { |v| @visited[v] = nil }
      @unvisited.unshift(@name)
    end

    def adjacent_and_unvisited(vertex)
      adjacent = @graph.adjacent_vertices(vertex)
      adjacent & @unvisited
    end

  end
end
