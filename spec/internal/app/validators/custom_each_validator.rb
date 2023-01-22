# frozen_string_literal: true

class CustomEachValidator < ActiveModel::EachValidator
  def validate_each(_record, _attribute, _value)
    true
  end
end
