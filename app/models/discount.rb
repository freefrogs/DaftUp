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
  validate :set_ok?
  validate :extra_ok?

  private

  def can_be_add?
    ids = Product.all.map { |e| e[:id] }
    added_ids = product_ids.uniq

    errors.add(:product_ids,
               :invalid, 
               message: 'Non-existent product id on the list') if added_ids.all? { |e| ids.include?(e) } == false
  end

  def set_ok?
    if kind == 'set'
      if product_ids.size < 2
        errors.add(:product_ids,
                   :invalid,
                   message: 'Set should have at least 2 products')
      elsif count != 0
        errors.add(:count,
                   :invalid,
                   message: 'When set count should be equal 0')
      elsif price == 0
        errors.add(:price,
                   :invalid,
                   message: 'Price should be greater then 0')
      end
    end
  end

  def extra_ok?
    if kind == 'extra'
      if price != 0
        errors.add(:price,
                   :invalid,
                   message: 'When extra price should be equal 0')
      elsif count == 0
        errors.add(:count,
                   :invalid,
                   message: 'Count should be greater then 0')
      end
    end
  end
end
