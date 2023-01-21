# frozen_string_literal: true

class Order < ActiveRecord::Base
  validates :item_count, :total, presence: true
  validates :item_count, numericality: { greater_than: 0.0 }
  validates :total, numericality: { only_integer: true, greater_than: 0 }
end
