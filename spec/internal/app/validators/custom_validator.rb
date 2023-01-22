# frozen_string_literal: true

class CustomValidator < ActiveModel::Validator
  def validate(_record)
    true
  end
end
