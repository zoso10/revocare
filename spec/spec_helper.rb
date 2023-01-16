# frozen_string_literal: true

require "revocare"

require "bundler"

Bundler.require :default, :development
Combustion.initialize! :active_record

require "rspec/rails"
require "support/file_helper"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.include FileHelper
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    FileHelper.reset!
  end

  config.before do
    stub_graphviz_library(present: true)
  end

  config.after do |example|
    if !example.metadata[:skip_file_cleanup]
      FileHelper.reset!
    end
  end
end
