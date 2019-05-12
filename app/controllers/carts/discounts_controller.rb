# frozen_string_literal: true

module Carts
  class DiscountsController < ApplicationController
    def create
      cart.discounts.create!(discount_params)

      render json: cart, status:201
    end
  
    def update
      discount.update!(discount_params)

      render json: cart
    end

    private
  
    def cart
      @cart = Cart.find(1)
    end

    def discount
      @discount ||= cart.discounts.find(params[:id])
    end

    def discount_params
      params.permit(:kind,
                    :name,
                    { product_ids: [] },
                    :price,
                    :count)
    end
  end
end