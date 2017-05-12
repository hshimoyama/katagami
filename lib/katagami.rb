require "active_model"
require "virtus"
require "katagami/version"
require "katagami/field"
require "katagami/validation"

module Katagami
  extend ActiveSupport::Concern

  included do
    include Virtus.model
    include ActiveModel::Model

    include Katagami::Field
    include Katagami::Validation
  end
end
