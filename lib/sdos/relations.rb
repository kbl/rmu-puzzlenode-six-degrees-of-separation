require 'sdos/graph/dijkstras_alg'
require 'sdos/graph/un_directed_graph'

module Sdos
  class Relations

    include Graph

    def initialize(parser)
      @relation_graph = UnDirectedGraph.new

      parser.parse do |tweet|
        @relation_graph << tweet
      end

      @relation_graph.strongly_connected_components!
    end

    def [](name)
      @relation_graph.adjacent_vertices(name)
    end

    def friends(name)
      DijkstrasAlg.new(@relation_graph, name).find_shortest_paths
    end

    def relations
      return @relations if @relations

      @relations = {}
      @relation_graph.each { |person| @relations[person] = friends(person) }

      @relations
    end

  end
end
