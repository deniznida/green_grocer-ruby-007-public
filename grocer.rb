require "pry"
def consolidate_cart(cart:[])
  # code here
  new_hash = {}
  cart.each do|product_hash|
    product_hash.each do |item, item_hash|
      if new_hash.has_key?(item)
        new_hash[item][:count] += 1
      else
        new_hash[item] = item_hash
        new_hash[item][:count] = 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon_hash|
    item = coupon_hash[:item] # save the coupon hash {:item=>"AVACADO, :num=>2, :const=>5.0}"}
      if cart.has_key?(item)
        origional_qty = cart[item][:count]
        coupon_qty = origional_qty / coupon_hash[:num] # this is the applied coupon qty
        new_remaining_qty_after_coupon_applied = origional_qty % coupon_hash[:num]
          if coupon_qty > 0
            cart[item][:count] = new_remaining_qty_after_coupon_applied
            cart["#{item} W/COUPON"] = {
            :price=> coupon_hash[:cost],
            :clearance=> cart[item][:clearance],
            :count=> coupon_qty }
          end
        end
      end
    cart
end


def apply_clearance(cart:[])
  cart.each do |item, item_detail_hash|
    if cart[item][:clearance] 
      cart[item][:price] = (cart[item][:price] * 0.80).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  # code here
  cart_total = 0
 
  consolidated = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consolidated, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)

  new_array = consolidated.collect do |item, properties|
    properties[:price] * properties[:count]
  end

  new_array.each do |x| 
    cart_total += x 
  end

  if cart_total >= 100
    cart_total = (cart_total * 0.9).round(2)
  end
  cart_total
end

