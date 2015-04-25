#!/usr/bin/env ruby

require_relative "objects"

            
discount40euro = lambda {|items, price|
                    if price > 40
                        price -= price * 5 / 100
                    end
                    price
                  }

discountBooks = lambda {|items, price|
                   items.map {|item| item[:item_price][:discounted]-=(item[:item_price][:real] * 12/100) if item[:item_type] == 'BOOK'; item}
                   items 
                }

discountGrocery = lambda {|items, price|
                     items.map {|item| item[:item_price][:discounted] -= (item[:item_price][:real] * 7.5 / 100) if item[:item_type] == 'GROCERY'; item}
                     items
                  }


test = Bill.new()
test.add_discount(Discount.new(discount40euro, volume=true))
test.add_discount(Discount.new(discountBooks))
test.add_discount(Discount.new(discountGrocery))
test.add_item(Item.new('GENERIC', 'Chocolate', 2.10), 10) 
test.add_item(Item.new('GENERIC', 'Apple', 0.50), 5)
test.add_item(Item.new('GENERIC', 'Wine', 10.5))
test.add_item(Item.new('BOOK', 'Book', 15.05))
test.receipt()     

test = Bill.new()
test.add_discount(Discount.new(discount40euro, volume=true))
test.add_discount(Discount.new(discountBooks))
test.add_discount(Discount.new(discountGrocery))
test.add_item(Item.new('GROCERY', 'Pasta', 4.29))
test.add_item(Item.new('BOOK', 'Book', 10.12))
test.receipt()     

test = Bill.new()
test.add_discount(Discount.new(discount40euro, volume=true))
test.add_discount(Discount.new(discountBooks))
test.add_discount(Discount.new(discountGrocery))
test.add_item(Item.new('GROCERY', 'Coffee', 3.21))
test.add_item(Item.new('GROCERY', 'Pasta', 4.29))
test.add_item(Item.new('GENERIC', 'Cake', 2.35))
test.receipt()     