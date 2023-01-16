# frozen_string_literal: true

class User < ActiveRecord::Base
  after_initialize :after_initialize_callback
  before_validation :before_validation_callback
  after_validation :after_validation_callback
  before_save :before_save_callback
  around_save :around_save_callback
  before_create :before_create_callback
  around_create :around_create_callback
  after_create :after_create_callback
  after_save :after_save_callback
  before_commit :before_commit_callback
  after_commit :after_commit_callback
  after_rollback :after_rollback_callback
  before_update :before_update_callback
  around_update :around_update_callback
  after_update :after_update_callback
  before_destroy :before_destroy_callback
  around_destroy :around_destroy_callback
  after_destroy :after_destroy_callback
  after_touch :after_touch_callback
  after_find :after_find_callback

  private

  def after_initialize_callback; end

  def before_validation_callback; end

  def after_validation_callback; end

  def before_save_callback; end

  def around_save_callback; end

  def before_create_callback; end

  def around_create_callback; end

  def after_create_callback; end

  def after_save_callback; end

  def before_commit_callback; end

  def after_commit_callback; end

  def after_rollback_callback; end

  def before_update_callback; end

  def around_update_callback; end

  def after_update_callback; end

  def before_destroy_callback; end

  def around_destroy_callback; end

  def after_destroy_callback; end

  def after_touch_callback; end

  def after_find_callback; end
end
