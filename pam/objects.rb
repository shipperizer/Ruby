#!/usr/bin/env ruby

TYPES = ["GROCERY", "BOOK", "GENERIC"]


class Item
    attr_accessor :name
    attr_accessor :price
    attr_accessor :item_type
    
    def initialize(item_type, name, price)
        if TYPES.include? item_type.upcase
            @item_type = item_type 
        else
            raise StandardError.new()  
        end    
        @name = name
        @price = {'real': price, 'discounted': price} 
    end    
end

class Discount
    attr_accessor :volume
    attr_accessor :function

    private :function

    def initialize(function, volume=false)
        @function = function
        @volume = volume        
    end
        
    def apply(items, price)
        @function.call(items, price) 
    end
end 

class Bill
    attr_accessor :items
    attr_accessor :discounts
    attr_reader :price
    
    def initialize
        # [{:item_name: 'Pasta 1Kg', :item_type: 'GROCERY', :item_price: {:real: 1, :discounted: 0.5}, :quantity: 15}, 
        # {:item_name: 'Coffee', :item_type: 'GROCERY', :item_price': {:real: 1, :discounted: 0.5}, :quantity: 15}]
        @items = []
        @discounts = {volume: [], type: []}
        @price = 0
    end
        
    def add_item(item, quantity=1)
        unless (@items.map {|item| item[:item_name]}).include? item.name
            @items.push({item_name: item.name, item_type: item.item_type, item_price: {real: item.price[:real], discounted: item.price[:discounted]}, quantity: quantity})    
        else
            @items.map {|bill_item| bill_item[:quantity] += quantity if bill_item[:item_name] == item.name}
        end
    end
                                 
    def add_discount(discount)
        if discount.volume
            @discounts[:volume].push(discount)
        else
            @discounts[:type].push(discount)
        end    
    end        
            
    def receipt
        @discounts[:type].each do |discount|
            discount.apply(@items, @price)
        end
        recalculate
        discount_price = @price
        @discounts[:volume].each do |discount|
            @price = discount.apply(@items, @price).round(2)
        end
        json = jsonize(discount_price) 
        puts "-------------------------------------------------------"   
        puts "-------------------------------------------------------"  
        puts "-Item----#----Price----Discount%----Discounted Price----------------------"  
        json[:items].each do |item|
            puts "#{item[:name]}    | #{item[:quantity]} | #{item[:price]} |     #{'%.02f' % item[:discount]}%    |    #{item[:price_discounted]}"      
        end
        puts "Gross total: #{json[:gross]}"
        puts "Volume discount: #{json[:vol_discount]}%"
        puts "Total price: #{'%.02f' % json[:final_price]}"
        puts "Total discount: #{'%.02f' % json[:tot_discount]}"
        puts "-------------------------------------------------------"   
        puts "-------------------------------------------------------"   
        puts ""
    end

    def jsonize(discount_price)
        json = {items:[], gross: 0, final_price: 0, vol_discount: 0, tot_discount: 0}
        full_price = 0
        @items.each do |item|
            discount =  (2 * 100 * (1 - item[:item_price][:discounted] / item[:item_price][:real])).round / 2.0  
            full_price += item[:quantity] * item[:item_price][:real] 
            json[:items].push({name: item[:item_name], quantity: item[:quantity], price: item[:item_price][:real], discount: discount, price_discounted: item[:item_price][:discounted]})      
        end
        json[:gross] = discount_price
        json[:vol_discount] = (100 * (1 - @price / discount_price)).round(2)
        @price = (@price*20).round / 20.0
        json[:final_price] = @price
        json[:tot_discount] = full_price - @price
        return json
    end
    
    def recalculate
        @items.map {|item| item[:item_price][:discounted]=item[:item_price][:discounted].round(2); item[:item_price][:real]=item[:item_price][:real].round(2); item }
        @items.each do |item|
            @price += item[:quantity] * item[:item_price][:discounted]
        end
        @price = @price.round(2)
    end

    private :recalculate
    private :jsonize
end

# ---------------------------------------------------------------------------------------------------------------------------
