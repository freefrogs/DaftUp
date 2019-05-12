# frozen_string_literal: true

module Carts
  class ItemsController < ApplicationController

    def create
      if check_quantity_create == false && product_already_in_cart == false
        cart.items.create!(item_params)

        render json: cart, status:201
      end
    end
  
    def update
      item.update!(item_params)

      check_quantity_update

      render json: cart
    end

    private
  
    def cart
      @cart = Cart.find(1)
    end

    def item
      @item ||= cart.items.find(params[:id])
    end

    def item_params
      params.permit(:product_id,
                    :quantity)
    end

    def check_quantity_create
      if params[:quantity] == 0
        render json: {message: 'Quantity should be greater than 0'}, status:400
      else
        false
      end
    end

    def product_already_in_cart
      items = Item.all
      added_product_id = params[:product_id]
      existing_product = items.select { |item| added_product_id == (item[:product_id]) }

      if existing_product.empty?
        false
      else
        added_q = params[:quantity]
        item_id = existing_product[0][:id]
        item_q = existing_product[0][:quantity]

        cart.items.find(item_id).update!(quantity: item_q + added_q)

        render json: cart
      end
    end

    def check_quantity_update
      if item.quantity == 0
        item.destroy!
      end
    end

  end
end