# frozen_string_literal: true

class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :kind, null: false
      t.string :name, null: false
      t.integer :product_ids, array: true, null: false, default: []
      t.float :price, default: 0
      t.integer :count, default: 0
      t.references :cart, foreign_key: true, index: true
      t.timestamps
    end
  end
end
