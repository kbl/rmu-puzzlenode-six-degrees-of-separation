require 'rgl/adjacency'

module Sdos
  class Relations

    include RGL

    def initialize(parser)
      @relation_graph = DirectedAdjacencyGraph.new

      parser.parse do |tweet|
        self.<<(tweet)
      end

      #@relation_graph = @relation_graph.strongly_connected_components
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
  end
end
