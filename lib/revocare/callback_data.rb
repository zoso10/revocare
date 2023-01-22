# frozen_string_literal: true

module Revocare
  class CallbackData
    INTERNAL_MODELS = [
      "ActiveRecord::InternalMetadata",
      "ActiveRecord::SchemaMigration",
    ].freeze

    def self.to_a
      new.to_a
    end

    def initialize
      @data = []
    end

    def to_a
      all_models.each do |model|
        callbacks = callbacks_for(model)

        if callbacks.any?
          data << {
            model: model.name,
            callbacks: format_callbacks(callbacks),
          }
        end
      end

      data
    end

    private

    attr_reader :data

    def all_models
      ::ActiveRecord::Base
        .descendants
        .reject { |model| INTERNAL_MODELS.include?(model&.name) }
        .sort_by(&:name)
    end

    def callbacks_for(model)
      {}.tap do |callbacks_acc|
        model.__callbacks.each do |_key, callback_chain|
          callback_chain.each do |callback|
            type = [callback.kind, callback.name].join("_")
            methods = extract_methods(callback.filter)
            callbacks_acc[type] ||= []
            callbacks_acc[type] += methods
          end
        end
      end.transform_values(&:reverse)
    end

    def format_callbacks(callbacks)
      callbacks.map do |name, chain|
        {
          callback_name: name,
          callback_chain: chain,
        }
      end
    end

    def extract_methods(callback_filter)
      if callback_filter.is_a?(ActiveModel::Validator)
        name = callback_filter.class.name.demodulize

        if callback_filter.respond_to?(:attributes)
          callback_filter.attributes.map do |attribute|
            [name, attribute].join(":")
          end
        else
          [name]
        end
      else
        [callback_filter.to_s]
      end
    end
  end
end
