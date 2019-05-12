# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
  	render json: products
  end
end

private

def products
  Product.all
end