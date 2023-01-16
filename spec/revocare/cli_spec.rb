# frozen_string_literal: true

RSpec.describe Revocare::CLI do
  before do
    Address.connection
    Product.connection
    User.connection
  end

  describe "initialization" do
    it "raises if `ActiveRecord` is not defined" do
      allow(Module).to receive(:const_defined?).and_call_original
      allow(Module).to receive(:const_defined?).with("ActiveRecord").and_return(false)

      expect do
        described_class.new
      end.to raise_error("Must use `ActiveRecord`")
    end

    it "loads the rails environment configuration file" do
      allow(Kernel).to receive(:require).with(/config\/environment.rb/).and_call_original

      described_class.new

      expect(Kernel).to have_received(:require).with(/config\/environment.rb/)
    end

    it "outputs a message if it could not load rails environment file" do
      expect do
        described_class.new
      end.to output("Tried to load Rails environment but could not find it\n").to_stdout
    end

    it "preloads the application if `Rails` is defined" do
      allow(ActiveRecord).to receive(:eager_load!).and_call_original
      allow(Rails.application).to receive(:eager_load!).and_call_original
      allow(Rails.application.config).to receive(:eager_load_namespaces).and_call_original

      described_class.new

      expect(Rails.application).to have_received(:eager_load!).twice
      expect(Rails.application.config).to have_received(:eager_load_namespaces)
      expect(ActiveRecord).to have_received(:eager_load!)
    end

    it "does not eager load namespaces if rails version does not support it" do
      allow(ActiveRecord).to receive(:eager_load!).and_call_original
      allow(Rails.application).to receive(:eager_load!).and_call_original
      allow(Rails.application.config).to receive(:respond_to?).with(:eager_load_namespaces).and_return(false)

      described_class.new

      expect(Rails.application).to have_received(:eager_load!).once
      expect(ActiveRecord).not_to have_received(:eager_load!)
    end
  end

  describe "#call" do
    it "writes all ActiveRecord callbacks to a file" do
      expect do
        described_class.call
      end.to change { File.exist?("callbacks.pdf") }.from(false).to(true)
    end
  end
end
