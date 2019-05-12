# frozen_string_literal: true

class Discount < ApplicationRecord
  KINDS = %w[set extra].freeze

  belongs_to :cart

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :count, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 0 }

  validate :can_be_add?
  validate :is_set_ok?
  validate :is_extra_ok?

  private

  def can_be_add?
    ids = Product.all.map { |e| e[:id] }
    added_ids = self.product_ids.uniq

    if added_ids.all? { |e| ids.include?(e) } == false
      errors.add( :product_ids, :invalid, message: "Non-existent product id on the list" )
    end
  end

  def is_set_ok?
    if self.kind == "set"
      if self.product_ids.size < 2 
        errors.add( :product_ids, :invalid, message: "Set should have at least 2 products" )
      elsif self.count != 0
        errors.add( :count, :invalid, message: "When set count should be equal 0" )
      elsif self.price == 0
        errors.add( :price, :invalid, message: "Price should be greater then 0" )
      end
    end
  end

  def is_extra_ok?
    if self.kind == "extra"
      if self.price != 0
        errors.add( :price, :invalid, message: "When extra price should be equal 0" )
      elsif self.count == 0
        errors.add( :count, :invalid, message: "Count should be greater then 0" )
      end
    end
  end
end
