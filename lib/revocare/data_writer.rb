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
      @graph = GraphViz.new(:G, type: :digraph)
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
        data.each_with_index do |model_data, index|
          model_node = add_model_node(model_data[:model])
          model_data[:callbacks].each do |callback|
            name, chain = callback.values_at(:callback_name, :callback_chain)
            name_node = add_callback_node(name, index)
            method_nodes = chain.each_with_index.map do |method, order|
              add_callback_chain_node(method, index, order)
            end

            graph.add_edge(model_node, name_node)
            graph.add_edges(name_node, method_nodes)
          end
        end

        graph.output(extension => filename)
      end
    end

    private

    attr_reader :data, :graph

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
      graph.add_node("#{name}#{index}", label: label || name, shape: shape)
    end
  end
end
