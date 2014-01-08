=begin
If you spend over £60, then you get 10% off your purchase
If you buy 2 or more travel card holders then the price drops to
£8.50.
=end

class Checkout
	attr_accessor :store
	attr_accessor :items
	attr_accessor :rules
	attr_accessor :total
	def initialize(promo_rules)
		@items = []
		@rules = promo_rules
		@store = { "001" => {name: "Travel Card Holder", price: 9.25}, "002" => {name: "Personalised cufflinks", price: 45.00}, "003" => {name: "T-shirt", price: "19.95"} }
	end

	def scan(item)
		@items << item.to_s
	end

	def total
		@total = 0
		@items.each do |item|
			@total+=@store[item][:price].to_f
		end
		evaluator
		@total.round(2)
	end

	def evaluator
		puts @rules
		@rules.each do |rule|
			puts "this is #{rule} #{rule[1][:code]}"
			if rule[1][:code]=="total"
				if @total >= rule[1][:quantity] 
					@total*=rule[1][:result].to_f
				end
			elsif @items.include?(rule[1][:code])
				if @items.count(rule[1][:code]) >= rule[1][:quantity]
					@total-=(@store[rule[1][:code]][:price]-rule[1][:result].to_f)*@items.count(rule[1][:code])
				end
			end					
		end
	end

	private :evaluator 

end


promotional_rules={"001" => { code: "001", quantity: 2, result:"8.5"}, "total"=> {code: "total", quantity: 60, result: "0.9"}}
co = Checkout.new(promotional_rules)
co.scan("001")
co.scan("003")
co.scan("001")
co.scan("002")
price = co.total
puts price

=begin
Basket: 001,002,003
Total price expected: £66.78
Basket: 001,003,001
Total price expected: £36.95
Basket: 001,002,001,003
Total price expected: £73.76
=end