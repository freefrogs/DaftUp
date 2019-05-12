# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    render json: cart
  end

  private

  def cart
    @cart ||= Cart.find(1)
  end
end
