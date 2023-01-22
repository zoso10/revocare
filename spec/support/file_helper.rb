# frozen_string_literal: true

require "faker"

module FileHelper
  class << self
    def reset!
      FileUtils.rmtree(Revocare::DataWriter::DEFAULT_DIRECTORY)
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
