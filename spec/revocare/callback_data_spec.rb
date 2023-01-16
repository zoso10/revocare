# frozen_string_literal: true

RSpec.describe Revocare::CallbackData do
  before do
    Address.connection
    Product.connection
    User.connection
  end

  describe "#to_a" do
    it "returns a collection of each model's callbacks" do
      data = described_class.new.to_a

      expect(data.length).to eq(3)
      expect(data).to eq(
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
            ]
          },
          {
            model: "Product",
            callbacks: [
              {
                callback_name: "before_validate",
                callback_chain: ["cant_modify_encrypted_attributes_when_frozen"],
              }
            ]
          },
          {
            model: "User",
            callbacks: [
              {
                callback_name: "before_validate",
                callback_chain: ["cant_modify_encrypted_attributes_when_frozen"],
              },
              {
                callback_name: "after_validation",
                callback_chain: ["after_validation_callback"],
              },
              {
                callback_name: "before_validation",
                callback_chain: ["before_validation_callback"],
              },
              {
                callback_name: "after_initialize",
                callback_chain: ["after_initialize_callback"],
              },
              {
                callback_name: "after_find",
                callback_chain: ["after_find_callback"],
              },
              {
                callback_name: "after_touch",
                callback_chain: ["after_touch_callback"],
              },
              {
                callback_name: "after_save",
                callback_chain: ["after_save_callback"],
              },
              {
                callback_name: "before_save",
                callback_chain: ["before_save_callback"],
              },
              {
                callback_name: "around_save",
                callback_chain: ["around_save_callback"],
              },
              {
                callback_name: "after_create",
                callback_chain: ["after_create_callback"],
              },
              {
                callback_name: "before_create",
                callback_chain: ["before_create_callback"],
              },
              {
                callback_name: "around_create",
                callback_chain: ["around_create_callback"],
              },
              {
                callback_name: "after_update",
                callback_chain: ["after_update_callback"],
              },
              {
                callback_name: "before_update",
                callback_chain: ["before_update_callback"],
              },
              {
                callback_name: "around_update",
                callback_chain: ["around_update_callback"],
              },
              {
                callback_name: "after_destroy",
                callback_chain: ["after_destroy_callback"],
              },
              {
                callback_name: "before_destroy",
                callback_chain: ["before_destroy_callback"],
              },
              {
                callback_name: "around_destroy",
                callback_chain: ["around_destroy_callback"],
              },
              {
                callback_name: "after_commit",
                callback_chain: ["after_commit_callback"],
              },
              {
                callback_name: "after_rollback",
                callback_chain: ["after_rollback_callback"],
              },
              {
                callback_name: "before_before_commit",
                callback_chain: ["before_commit_callback"],
              },
            ]
          },
        ]
      )
    end
  end
end
