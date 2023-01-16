# frozen_string_literal: true

require "faker"

module FileHelper
  class << self
    attr_writer :filenames

    def new_filename!(extension: "pdf")
      @filenames ||= []

      Faker::File.file_name(dir: ".", ext: extension).tap do |filename|
        @filenames.push(filename)
      end
    end

    def reset!
      @filenames ||= []
      @filenames.each(&FileUtils.method(:rm_rf))
      @filenames = []

      FileUtils.rm_f(Revocare::DataWriter::DEFAULT_FILENAME)
    end
  end

  def stub_graphviz_library(present: true)
    allow(Kernel).to receive(:system).with("which dot").and_return(present)
  end

  def stub_rails_environment_file(present: true)
    if present
      allow(Kernel).to receive(:require).with(/config\/environment.rb/).and_return(true)
    else
      allow(Kernel).to receive(:require).with(/config\/environment.rb/).and_raise(LoadError)
    end
  end
end
