# frozen_string_literal: true

class Address < ActiveRecord::Base
  before_save :set_defaults
  after_save :perform_magic
  after_save :wreak_havoc
  after_save :cleanup

  private

  def set_defaults; end

  def perform_magic; end

  def wreak_havoc; end

  def cleanup; end
end
