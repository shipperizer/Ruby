class Calculator
	
	@@instances=[]
	def initialize (init=0)
		@result= init
		@undo=nil
		@memory= nil
		@@instances << self
	end

	def self.instances
		@@instances
	end

	def result
		!@result.nil? && @result.to_f == @result.to_i ? @result.to_i : @result.to_f 
	end

	def result=(num)
		last_ops
		@result= num.to_f
	end

	def clear_all
		last_ops
		@result=0
	end

	def add(num)
		last_ops
		@result+=num.to_f
		self
	end

	def subtract(num)
		last_ops
		@result-=num.to_f
		self
	end

	def multiply_by (num)
		last_ops
		@result*=num.to_f
		self
	end

	def divide_by (num)
		last_ops
		@result/=num.to_f
		self
	end

	def input (expr=nil)
		last_ops
		if block_given?
			@result= yield @result
		else
			uExpr=uniformize(expr)
			if uExpr[:num][0].nil? 
		 		puts "Error on input";
		 		return
		 	end
		 	#check if ops and numbers are of the same length, in that case we keep the @result as it is and do not set it at the first value of the expression
		 	probe= uExpr[:num].count == uExpr[:ops].count ? 0 : 1 
		 	@result= probe == 1 ? uExpr[:num][0].to_f : @result
		 	for i in probe..uExpr[:ops].count 
		 		case uExpr[:ops][i-1]
			 		when "+"
			 			add(uExpr[:num][i].to_f)
			 		when "-"
			 			subtract(uExpr[:num][i].to_f)
			 		when "*"
			 			multiply_by(uExpr[:num][i].to_f)
			 		when "/"
			 			divide_by(uExpr[:num][i].to_f)
			 		else
		  				puts "I have no idea what to do with that."
		  				return
				end
			end
		end
		self
	end

	def clear
		@result = @undo
		self
	end

	def memory(name=:default)
		if @memory.nil? 
			@memory={}
		end
		if @memory[name.to_sym].nil? 
				@memory[name.to_sym]=Memory.new
		end
		@memory[name.to_sym]		
	end

	def store_in_memory(name=:default)
		@memory={} if @memory.nil?
		@memory[name.to_sym] = Memory.new(@result)
	end

	def get_memory(name=:default)
		@memory.nil? || @memory[name.to_sym].nil? ? nil : @memory[name.to_sym].result 
	end

	def add_to_memory(name=:default)
		@memory[name.to_sym].add(@result)
	end

	def subtract_from_memory(name=:default)
		@memory[name.to_sym].subtract(@result)
	end

	def clear_memory(name=:default)
		@memory[name.to_sym]=nil
	end
	
	def clear_all_memory
		@memory=nil
	end	

	alias_method :plus, :add
	alias_method :minus, :subtract	

	private

	def uniformize (expr)
		uni={:ops, :num}
		uni[:num] = expr.gsub(/÷/,"/").gsub(/[×xX]/,"*").gsub("**","*").gsub(" ","").split(%r{[\/\+\-\*]}).reject {|el| el.empty? }
		uni[:ops] = expr.gsub(/÷/,"/").gsub(/[×xX]/,"*").gsub("**","*").gsub(" ","").split(%r{[\d\.]}).reject {|el| el.empty? }
		return uni
	end

	def last_ops
		@undo = @result
	end

	def self.clear_instances
		@@instances=[]
	end

end

class Memory < Calculator
	def initialize (init=0)
		@result= init
		@undo=nil
	end
end

class Integer
	def add(num)
		return Calculator.new(self).add(num).result.to_i
	end

	def subtract(num)
		return Calculator.new(self).subtract(num).result.to_i
	end

	def multiply_by(num)
		return Calculator.new(self).multiply_by(num).result.to_i
	end

	def divide_by(num)
		return Calculator.new(self).divide_by(num).result.to_i
	end

	def calculate_input(expr)
		return Calculator.new.input(self.to_s+expr).result.to_i
	end

	def calculate
		Calculator.new(self)
	end
end

class Float
	def add(num)
		return Calculator.new(self).add(num).result.to_f
	end

	def subtract(num)
		return Calculator.new(self).subtract(num).result.to_f
	end

	def multiply_by(num)
		return Calculator.new(self).multiply_by(num).result.to_f
	end

	def divide_by(num)
		return Calculator.new(self).divide_by(num).result.to_f
	end

	def calculate_input(expr)
		return Calculator.new.input(self.to_s+expr).result.to_f
	end

	def calculate
		Calculator.new(self)
	end
end
