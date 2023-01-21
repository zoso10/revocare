# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table(:users, force: true) do |t|
    t.string :shoe_size
    t.timestamps
  end

  create_table(:addresses, force: true) do |t|
    t.belongs_to :user
    t.timestamps
  end

  create_table(:products, force: true) do |t|
    t.belongs_to :user
    t.timestamps
  end

  create_table(:orders, force: true) do |t|
    t.integer :item_count
    t.integer :total
    t.timestamps
  end
end
