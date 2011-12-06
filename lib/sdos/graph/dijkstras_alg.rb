require 'sdos/graph/utils'

module Sdos
  module Graph
    class DijkstrasAlg

      include Utils

      def initialize(graph, name)
        @graph, @name, @vertex = graph, name, name
      end

      def find_shortest_paths
        return @path_costs if @path_costs

        initialize_visited_unvisited

        until @unvisited.empty? do
          adjacent_and_unvisited.each do |adjacent_vertex|
            update_adjacent_vertex_path_cost(adjacent_vertex)
          end

          @unvisited.delete(@vertex)
          move_to_nearest_vertex
        end

        @path_costs.delete(@name)
        @path_costs = reverse_map(@path_costs)
      end

      private

      def initialize_visited_unvisited
        @path_costs = {}
        @path_costs[@name] = 0

        @unvisited = @graph.to_a
        @unvisited.delete(@name)
        @unvisited.each { |v| @path_costs[v] = nil }
        @unvisited.unshift(@name)
      end

      def adjacent_and_unvisited
        adjacent = @graph.adjacent_vertices(@vertex)
        adjacent & @unvisited
      end

      def move_to_nearest_vertex
        @unvisited.sort do |a, b|
          result = @path_costs[a] <=> @path_costs[b]
          result || -1
        end
        @vertex = @unvisited.shift
      end

      def update_adjacent_vertex_path_cost(adjacent_vertex)
        new_path_cost = @path_costs[@vertex] + 1
        adjacent_cost = @path_costs[adjacent_vertex]

        if adjacent_cost.nil?
          @path_costs[adjacent_vertex] = new_path_cost
        elsif adjacent_cost > new_path_cost
          @path_costs[adjacent_vertex] = new_path_cost
        end
      end

    end
  end
end
