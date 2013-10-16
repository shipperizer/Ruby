require 'yaml'

class VendingMachine
	attr_accessor :funds
	attr_accessor :price
	attr_accessor :selection
	attr_accessor :change
	attr_accessor :cash
	@@admin_pass=6666
	@@products_file="products"
	@@mint=[0.01,0.02,0.05,0.1,0.2,0.5,1,2]
	def initialize
		@funds=50.00
		@cash=0
		begin
    		@data = YAML.load(File.open(Dir.pwd+File::SEPARATOR+@@products_file).read)
    	rescue
      		raise "Can't load bot data"
      	end
    end

    def selection
    	while true
	    	puts "1. vending machine"
	    	puts "2. owner access"
	    	print "Select option: "
	    	input=gets.chomp
	       	if input.to_i == 1
		    	std_vending
		    elsif input.to_i == 2
		    	admin_vending
		    else 
		    	puts "echo off"
		    end
		end
	end
    
    def std_vending
    	while true
		   	list_all_products
	    	
	    	@selection=gets.chomp
	    	if @data[:products][@selection.to_i-1] && @data[:products][@selection.to_i-1][3].to_i > 0
	    		@price=@data[:products][@selection.to_i-1][2].to_f
	    		puts "#{@data[:products][@selection.to_i-1][1]} costs #{@data[:products][@selection.to_i-1][2]}£"
	    		print "Insert coins: 1p, 2p, 5p, 10p, 20p, 50p, £1, £2 ---> "
	    		@cash=coins(gets.chomp)
	    		if @cash==@price

	    		else
	    			while @cash < @price
	    				puts "#{@cash.to_i}£ and #{(@cash*100%100).to_i}p inserted so far, need more money"
	    				@cash+=coins($stdin.gets)
	    			end
	    		end

		   		if confirm
	    			@funds+=@price
	    			@change=@cash - @price
	    			@data[:products][@selection.to_i-1][3]-=1
	    			f = File.open(Dir.pwd+File::SEPARATOR+@@products_file, "a+")
	    			f.puts @data.to_yaml
	    			f.close
	    		else
	    			@change=@cash
	    		end	

	    		puts "Return #{@change.to_i}£ and #{(@change*100%100).to_i}p" unless @change==0
	    		puts "Thank you very much"
	    		@cash=0
	    		@change=0
	    	else 
	    		puts "No products with that code"
	    		puts "Do you want to exit vending mode?"
	    		break if confirm
	    	end
		end
    end

	def admin_vending
		admin=false
		puts "Admin password: "
		while true and gets.chomp.to_i==@@admin_pass
	    	puts "1. Refund/Withdraw machine"
	    	puts "2. Increment products stock"
	    	print "Select option: "
	    	input=gets.chomp
	    	if input.to_i == 1
		    	atm_admin
		    elsif input.to_i == 2
		    	stock_admin
		    else 
		    	puts "No options with that code"
	    		puts "Do you want to exit admin mode?"
	    		admin = true
	    		break if confirm
		    end
		end
		puts "Wrong password" if admin==false
	end
	
	private
    
    def coins(coin, admin=false)
    	
    	if coin.match(/\d+p/)
    		instant_coin=coin.gsub("p","").to_f / 100
    	elsif coin.match(/£\d+/)
    		instant_coin=coin.gsub("£","").to_i
    	else
    		instant_coin=0
    	end

    	if admin
    		instant_coin
    	else
    		if @@mint.index(instant_coin)
    		instant_coin
    		else
    		puts "Invalid Coin"
    		return 0
			end    		 	 
		end
    end

	def list_all_products(admin=false)
    	print "Code|Name|Price"
    	print "|Pieces" if admin
    	puts ""
    	@data[:products].each do |product|
    		print product[0]," - ",product[1]," - ",product[2]
    		print " - ",product[3] if admin
    		print "\n"
    	end
    	print "Select Product Code: "
    end

    def confirm
    	print "Are you sure?Confirm with Y, cancel with N...."
    	gets.chomp.downcase == "y"
    end

    def atm_admin
    	puts "Insert amount to refund/withdraw: Xp for pence, £X for pound"
    	@cash=coins(gets.chomp,true)
    	puts "1. Refund"
	    puts "2. Withdraw"
	    input=gets.chomp
	    if input.to_i == 1
		    @funds+=@cash
		elsif input.to_i == 2 && @funds > @cash
		    @funds-=@cash	
		else
			puts "No operation, too few money or wrong code"    	
		end
		@cash=0
    end

    def stock_admin
    	puts "1. Restock"
	    puts "2. Add new product"
	    print "Select option: "
	    input=gets.chomp
	    if input.to_i == 1
		    restock
		elsif input.to_i == 2
		    new_prod
		else
			puts "No operation"    	
		end
    end

    def restock
    	list_all_products(true)
    	@selection=gets.chomp
    	print "Insert pieces to add: "
    	input=gets.chomp
    	@data[:products][@selection.to_i-1][3]+=input.to_i
    	f = File.open(Dir.pwd+File::SEPARATOR+@@products_file, "a+")
		f.puts @data.to_yaml
		f.close
    end

    def new_prod
    	puts "Insert Name|Price in pound|Pieces"
    	puts "Example: 'M&M 1.42 100'"
    	input=gets.chomp
    	puts "#{@data[:products].size} size"
    	@data[:products] << [@data[:products].size+1]+[input.split[0]]+[input.split[1].to_f]+[input.split[1].to_i] 
    	f = File.open(Dir.pwd+File::SEPARATOR+@@products_file, "w+")
		f.puts @data.to_yaml
		f.close
		begin
    		@data = YAML.load(File.open(Dir.pwd+File::SEPARATOR+@@products_file).read)
    	rescue
      		raise "Can't load bot data"
      	end
      	puts "Added"
    end

end