# frozen_string_literal: true

class DiscountSerializer < ActiveModel::Serializer
  attributes :id, :kind, :name, :product_ids, :count_or_price

  def count_or_price
    if self.object.kind == "set"
      { price: self.object.price }
    else
      { count: self.object.count }
    end
  end
end
