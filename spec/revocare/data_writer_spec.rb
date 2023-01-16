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
            callback_chain: ["cleanup", "wreak_havoc", "perform_magic"],
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
  let(:filename) { FileHelper.new_filename! }
  let(:default_filename) { "callbacks.pdf" }

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

  describe "#write_to_file" do
    it "creates a file from the specified filename" do
      writer = described_class.new(data: data)

      expect do
        writer.write_to_file(filename: filename)
      end.to change { File.exist?(filename) }.from(false).to(true)
    end

    it "uses a default filename" do
      writer = described_class.new(data: data)

      expect do
        writer.write_to_file
      end.to change { File.exist?(default_filename) }.from(false).to(true)
    end

    it "writes the data as graphviz" do
      writer = described_class.new(data: data)
      file = FileHelper.new_filename!(extension: "dot")

      writer.write_to_file(filename: file)

      contents = File.read(file)
      expect(contents).to start_with("digraph G {")
      expect(contents).to include("label=Address")
      expect(contents).to include("label=perform_magic")
      expect(contents).to include("Address -> after_save")
      expect(contents).to include("after_save -> cleanup")
      expect(contents).to include("label=Product")
      expect(contents).to include("label=User")
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