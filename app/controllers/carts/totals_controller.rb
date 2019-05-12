# frozen_string_literal: true

module Carts
  class TotalsController < ApplicationController
    def show
      render json: summary.to_json
    end

    private

    def cart
      Cart.find(1)
    end

    def products
      Product.all
    end

    def product_list
      cart.items.all
    end

    def discounts
      cart.discounts.all
    end

    def regular_price
      product_list.sum { |e| e.quantity * products.find(e.product_id).price }
    end

    def final_price
      ids = product_list.map { |e| Array.new(e.quantity, e.product_id) }.sum

      total_price = discounts.map { |e|

        if e.kind == 'set'

          ids_list = ids
          common_part = (e.product_ids & ids_list).flat_map { |n| [n] * [e.product_ids.count(n), ids_list.count(n)].min }

          if e.product_ids.length == common_part.length
            e.product_ids.map { |n| ids_list.delete_at(ids_list.index(n)) }
            ids = ids_list
            e.price
          end

        else
          count = e.count + 1
          extra_ids = e.product_ids.map { |n| Array.new(count, n) }

          extra_ids.map { |arr|

            ids_list = ids
            common_part = ids_list.each_with_object(arr.dup).map{ |v, t| v if (l = t.index v) && t.slice!(l) }.compact

            if arr.length == common_part.length
              arr.map { |n| ids_list.delete_at(ids_list.index(n)) }
              ids = ids_list
              products.find(arr.uniq)[0][:price] * e.count
            end
          }
        end
      }.compact.flatten.compact.sum

      regular_products_price = ids.sum { |e| products.find(e).price }
      total_price += regular_products_price.round(2)
    end

    def summary
      {
        "products in cart": product_list,
        "your dicounts": discounts,
        "regular price": regular_price,
        "final price": final_price
      }
    end

  end
end

# methods for common part
#1) common_part = ids.each_with_object(sets_ids.dup).map{|v,t| v if (l = t.index v) && t.slice!(l) }.compact
#2) (array1 & array2).flat_map { |n| [n]*[array1.count(n), array2.count(n)].min }
#3) short_arr.map { |e| long_arr.delete_at(long_arr.index(e)) } 
#   when we do "return long_arr" we will get long_arr minus short_arr (with doubles)