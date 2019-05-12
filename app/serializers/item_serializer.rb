# frozen_string_literal: true

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_id, :product
end
