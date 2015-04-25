#!/usr/bin/env ruby

require "test/unit"
require_relative "objects"

class TestObjects < Test::Unit::TestCase
  
  def test_good_item
    test_i = Item.new("GROCERY", "book", 15)
    assert_equal("GROCERY", test_i.item_type)
    assert_equal("book", test_i.name)
    assert_equal({'real': 15, 'discounted': 15}, test_i.price)
  end
 
  def test_bad_item
  	assert_raise( StandardError ) {Item.new("UNKNOWN", 'book', 5)}
  end	 

  def test_discount
  	zero_f = lambda {|a, b| a.map {|el| el=0; el}}
  	array_test = [1,2,3,4]
  	offer = Discount.new(zero_f)
  	assert_equal(false, offer.volume)
  	assert_equal([0,0,0,0], offer.apply(array_test, 0))
  end

  def test_discount_volume
  	dumb_f = lambda {|a, b| b/2}
  	offer = Discount.new(dumb_f, true)
  	assert_equal(true, offer.volume)
  	assert_equal(2, offer.apply(nil, 4))
  end

  def test_bill
  	bill = Bill.new()
  	assert_equal([], bill.items)
  	assert_equal(0, bill.price)
  	assert_equal({volume: [], type: []}, bill.discounts)
  end

  def test_bill_add_item
  	bill = Bill.new()
  	item = Item.new("GROCERY", "book", 15)
  	bill.add_item(item)
  	assert_equal(1, bill.items.length)
  	assert_equal(1, bill.items[0][:quantity])
  	assert_equal(item.name, bill.items[0][:item_name])
  	bill.add_item(item)
  	assert_equal(1, bill.items.length)
  	assert_equal(2, bill.items[0][:quantity])
  end

  def test_bill_add_items
  	bill = Bill.new()
  	item = Item.new("GROCERY", "book", 15)
  	bill.add_item(item, 5)
  	assert_equal(1, bill.items.length)
    assert_equal(5, bill.items[0][:quantity])
  	assert_equal(item.name, bill.items[0][:item_name])
  end
  
  def test_bill_add_discount_type
  	bill = Bill.new()
  	dumb_f = lambda {|a, b| b/2}
  	offer = Discount.new(dumb_f, false)
  	bill.add_discount(offer)
    assert_equal(1, bill.discounts[:type].length)
    assert_equal([offer], bill.discounts[:type])
  end

  def test_bill_add_discount_volume
  	bill = Bill.new()
  	dumb_f = lambda {|a, b| b/2}
  	offer = Discount.new(dumb_f, true)
  	bill.add_discount(offer)
	  assert_equal(1, bill.discounts[:volume].length)
    assert_equal([offer], bill.discounts[:volume])  	
  end

  def test_input_1
  	discountBooks = lambda {|items, price|
                   items.map {|item| item[:item_price][:discounted]-=(item[:item_price][:real] * 12/100) if item[:item_type] == 'BOOK'; item}
                   items 
                }
    discountGrocery = lambda {|items, price|
                     items.map {|item| item[:item_price][:discounted] -= (item[:item_price][:real] * 7.5 / 100) if item[:item_type] == 'GROCERY'; item}
                     items
                  }
    test = Bill.new()
  	test.add_discount(Discount.new(discountGrocery))
  	test.add_discount(Discount.new(discountBooks))
  	test.add_item(Item.new('GROCERY', 'Pasta', 4.29))
  	test.add_item(Item.new('BOOK', 'Book', 10.12))
  	test.receipt()   
  	assert_equal(12.90, test.price)
  	assert_equal(2, test.items.length)
    assert_equal(1, test.items[0][:quantity])
  end
  
  def test_input_2
  	discountBooks = lambda {|items, price|
                   items.map {|item| item[:item_price][:discounted]-=(item[:item_price][:real] * 12/100) if item[:item_type] == 'BOOK'; item}
                   items 
                }
    discountGrocery = lambda {|items, price|
                     items.map {|item| item[:item_price][:discounted] -= (item[:item_price][:real] * 7.5 / 100) if item[:item_type] == 'GROCERY'; item}
                     items
                  }
    test = Bill.new()
  	test.add_discount(Discount.new(discountGrocery))
  	test.add_item(Item.new('GROCERY', 'Coffee', 3.21))
  	test.add_item(Item.new('GROCERY', 'Pasta', 4.29))
  	test.add_item(Item.new('GENERIC', 'Cake', 2.35))
  	test.receipt()   
  	assert_equal(9.30, test.price)
  	assert_equal(3, test.items.length)
    assert_equal(1, test.items[0][:quantity])
  end

  def test_input_3
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
    test = Bill.new()
    test.add_discount(Discount.new(discount40euro, volume=true))
    test.add_discount(Discount.new(discountBooks))
    test.add_item(Item.new('GENERIC', 'Chocolate', 2.10), 10) 
    test.add_item(Item.new('GENERIC', 'Apple', 0.50), 5)
    test.add_item(Item.new('GENERIC', 'Wine', 10.5))
    test.add_item(Item.new('BOOK', 'Book', 15.05))
    test.receipt()   
    assert_equal(44.90, test.price)
    assert_equal(4, test.items.length)
    assert_equal(10, test.items[0][:quantity])
    assert_equal(5, test.items[1][:quantity])
  end

  def test_input_4
    # 3=2+1, 6=4+2, 7=5+2 
    discount3for2 = lambda {|items, price|
                    items.map {|item| item[:quantity]-=(item[:quantity]/3).to_i if item[:quantity]>=3; item }
                    items
                 }
    test = Bill.new()
    test.add_discount(Discount.new(discount3for2))
    test.add_item(Item.new('GENERIC', 'Chocolate', 2.0), 10) 
    test.add_item(Item.new('GENERIC', 'Apple', 1.0), 5)
    test.receipt()   
    assert_equal(18, test.price)
    assert_equal(7, test.items[0][:quantity])
    assert_equal(4, test.items[1][:quantity])             
  end
end

