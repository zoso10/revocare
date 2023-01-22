# frozen_string_literal: true

RSpec.describe Revocare::DataWriter do
  let(:data) do
    [
      {
        model: "Address",
        callbacks: [
          {
            callback_name: "before_validate",
            callback_chain: ["cant_modify_encrypted_attributes_when_frozen"],
          },
          {
            callback_name: "after_save",
            callback_chain: ["perform_magic", "wreak_havoc", "cleanup"],
          },
          {
            callback_name: "before_save",
            callback_chain: ["set_defaults"],
          },
        ],
      },
      {
        model: "Product",
        callbacks: [
          {
            callback_name: "before_validate",
            callback_chain: ["cant_modify_encrypted_attributes_when_frozen"],
          },
        ],
      },
      {
        model: "User",
        callbacks: [
          {
            callback_name: "before_validate",
            callback_chain: ["cant_modify_encrypted_attributes_when_frozen"],
          },
        ],
      },
    ]
  end
  let(:directory_name) { FileHelper.new_directory! }

  before do
    stub_graphviz_library(present: true)
  end

  describe "initialization" do
    it "raises if the format is not recognized" do
      expect do
        described_class.new(data: data, format: :foobar)
      end.to raise_error(ArgumentError, "Data format is not supported")
    end
  end

  describe "#write_to_directory" do
    it "creates a directory if it does not exist" do
      writer = described_class.new(data: data)

      expect do
        writer.write_to_directory
      end.to change { Dir.exist?("./callbacks") }.from(false).to(true)
    end

    it "writes an individual file for each model" do
      writer = described_class.new(data: data)

      expect do
        writer.write_to_directory
      end.to change { File.exist?("./callbacks/address.pdf") }.from(false).to(true)
        .and change { File.exist?("./callbacks/product.pdf") }.from(false).to(true)
        .and change { File.exist?("./callbacks/user.pdf") }.from(false).to(true)
    end

    it "writes the data as graphviz format with `dot` extension" do
      writer = described_class.new(data: data)

      writer.write_to_directory(extension: "dot")

      address_contents = File.read("./callbacks/address.dot")
      product_contents = File.read("./callbacks/product.dot")
      user_contents = File.read("./callbacks/user.dot")
      expect(address_contents).to start_with("digraph G {")
      expect(address_contents).to include("rankdir=LR")
      expect(address_contents).to include("label=Address")
      expect(address_contents).to include("label=\"1) #perform_magic\"")
      expect(address_contents).to include("Address -> \":after_save0\"")
      expect(address_contents).to include("\":after_save0\" -> cleanup")
      expect(product_contents).to start_with("digraph G {")
      expect(product_contents).to include("label=Product")
      expect(user_contents).to start_with("digraph G {")
      expect(user_contents).to include("label=User")
    end
  end

  describe "#format" do
    it "defaults to graphviz format" do
      writer = described_class.new(data: data)

      expect(writer.format).to eq(:graphviz)
    end

    it "outputs when necessary graphviz libraries are present" do
      writer = described_class.new(data: data)

      expect do
        writer.format
      end.to output("Graphviz libraries found\n").to_stdout
    end

    it "raises if the necessary graphviz libraries are not present" do
      stub_graphviz_library(present: false)
      writer = described_class
        .new(data: data, format: described_class::GRAPHVIZ_FORMAT)

      expect do
        writer.format
      end.to raise_error(RuntimeError, "Graphviz libraries are not present")
    end
  end
end
