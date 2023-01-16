# frozen_string_literal: true

require "revocare"

module Revocare
  class CLI
    def self.call
      new.call
    end

    def initialize
      environment_path = "#{Dir.pwd}/config/environment.rb"
      Kernel.require environment_path

      if Module.const_defined?("Rails")
        Rails.application.eager_load!

        if Rails.application.config.respond_to?(:eager_load_namespaces)
          Rails.application.config.eager_load_namespaces.each(&:eager_load!)
        end

        if !Module.const_defined?("ActiveRecord")
          raise "Must use `ActiveRecord`"
        end
      end
    rescue LoadError
      puts "Tried to load Rails environment but could not find it"
    end

    def call
      data = Revocare::CallbackData.to_a
      writer = Revocare::DataWriter.new(data: data)
      writer.write_to_file
    end
  end
end
