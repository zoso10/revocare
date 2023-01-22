# frozen_string_literal: true

module Revocare
  class DataWriter
    GRAPHVIZ_FORMAT = :graphviz
    DEFAULT_FORMAT = GRAPHVIZ_FORMAT
    SUPPORTED_FORMATS = [
      GRAPHVIZ_FORMAT,
    ].freeze
    DEFAULT_DIRECTORY = "./callbacks"
    DEFAULT_EXTENSION = "pdf"

    def initialize(data:, format: DEFAULT_FORMAT)
      @graphs = []
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

    def write_to_directory(extension: DEFAULT_EXTENSION)
      FileUtils.mkdir_p(DEFAULT_DIRECTORY)

      if format == GRAPHVIZ_FORMAT
        data.each_with_index do |model_data, index|
          @current_graph = GraphViz.new(:G, type: :digraph, rankdir: "LR")

          model_name = model_data[:model]
          model_node = add_model_node(model_name)

          model_data[:callbacks].each do |callback|
            name, chain = callback.values_at(:callback_name, :callback_chain)
            name_node = add_callback_node(name, index)

            method_nodes = chain.each_with_index.map do |method, order|
              add_callback_chain_node(method, index, order)
            end

            current_graph.add_edge(model_node, name_node)
            current_graph.add_edges(name_node, method_nodes)
          end

          filename = "#{DEFAULT_DIRECTORY}/#{model_name.downcase}.#{extension}"
          current_graph.output(extension => filename)
        end
      end
    end

    private

    attr_reader :data, :graphs, :current_graph

    def validate_format!
      if !SUPPORTED_FORMATS.include?(@format)
        raise ArgumentError, "Data format is not supported"
      end
    end

    def add_model_node(name)
      add_node(name, nil, :box)
    end

    def add_callback_node(name, index)
      add_node(":#{name}", index, :diamond)
    end

    def add_callback_chain_node(name, index, order)
      label = "#{order + 1}) ##{name}"
      add_node(name, index, :ellipse, label)
    end

    def add_node(name, index, shape, label = nil)
      current_graph.add_node("#{name}#{index}", label: label || name, shape: shape)
    end
  end
end
