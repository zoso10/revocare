# frozen_string_literal: true

module Revocare
  class DataWriter
    GRAPHVIZ_FORMAT = :graphviz
    DEFAULT_FORMAT = GRAPHVIZ_FORMAT
    SUPPORTED_FORMATS = [
      GRAPHVIZ_FORMAT,
    ].freeze
    DEFAULT_FILENAME = "callbacks.pdf"

    def initialize(data:, format: DEFAULT_FORMAT)
      @data = data
      @format = format
      validate_format!
    end

    def format
      if @format == GRAPHVIZ_FORMAT
        if Kernel.system("which dot")
          puts "Graphviz libraries found"
        else
          raise "Graphviz libraries are not present"
        end
      end

      @format
    end

    def write_to_file(filename: DEFAULT_FILENAME)
      extension = File.extname(filename).tr(".", "").to_sym

      if format == GRAPHVIZ_FORMAT
        graph = GraphViz.new(:G, type: :digraph)

        data.each do |model_data|
          model_node = graph.add_node(model_data[:model])
          model_data[:callbacks].each do |c|
            name_node = graph.add_node(c[:callback_name])
            graph.add_edge(model_node, name_node)
            method_nodes = c[:callback_chain].map(&graph.method(:add_node))
            graph.add_edges(name_node, method_nodes)
          end
        end

        graph.output(extension => filename)
      end
    end

    private

    attr_reader :data

    def validate_format!
      if !SUPPORTED_FORMATS.include?(@format)
        raise ArgumentError, "Data format is not supported"
      end
    end
  end
end
