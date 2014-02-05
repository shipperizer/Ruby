class Calculator
	
	@@instances=[]
	def initialize (init=0)
		@result= init
		@undo=nil
		@memory= {}
		@@instances << self
	end

	def self.instances
		@@instances
	end

	def result
		puts !@result.nil? && @result.to_f == @result.to_i ? @result.to_i : @result.to_f 
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

	def memory
		puts @memory[:default].to_f == @memory[:default].to_i ? @memory[:default].to_i : @memory[:default].to_f 
	end

	def store_in_memory(name=:default)
		@memory[name.to_sym] = @result
	end

	def get_memory(name=:default)
		puts @memory[name.to_sym]
	end

	def add_to_memory
		@memory[]+=@result
	end

	def subtract_from_memory
		@memory-=@result
	end

	def clear_memory(name=:default)
		@memory[name.to_sym]=nil
	end
	
	def clear_all_memory
		@memory={}
	end	

	alias_method :plus, :add
	alias_method :minus, :subtract	

	private

	def uniformize (expr)
		uni={:ops, :num}
		uni[:num] = expr.gsub(/÷/,"/").gsub(/[×xX]/,"*").gsub("**","*").gsub(" ","").split(%r{[\/\+\-\*]}).reject {|el| el.empty? }
		uni[:ops] = expr.gsub(/÷/,"/").gsub(/[×xX]/,"*").gsub("**","*").gsub(" ","").split(%r{\d}).reject {|el| el.empty? }
		return uni
	end

	def last_ops
		@undo = @result
	end



end

calc = Calculator.new
calc.result # 0
#Result can be set at initiation

calc = Calculator.new 13
calc.result # 13
#The current result can be set

calc.result = 10
calc.result # 10
#The current result can be reset

calc.clear_all
calc.result # 0

#The result should be returned as integer if it is a whole number otherwise a float
calc.result = 5.0
calc.result # 5

calc.divide_by 2
calc.result # 2.5
#Basic operations

#The current result can be added to
calc = Calculator.new
calc.add("5").result # 5
#Subtracted from
calc.subtract("2").result # 3
#Multiplied
calc.multiply_by("4").result # 12
#Divided
calc.divide_by("3").result # 4

#Input interprets an indefinatly long string of operations

calc = Calculator.new
calc.input("1+1").result # 2
calc.input("3 - 1").result # 2
calc.input("6 ÷ 5").result # 1.2
calc.input("6 / 5").result # 1.2
calc.input("3 + 4 * 2").result # 14
calc.input("3 + 4 × 2").result # 14
calc.input("1 - 1+1").result # 1

#Input can also take a block for custom operations.
calc.result = 3
calc.input do |x|
  x**2
end.result # 9

#Operations can be chained
calc = Calculator.new
calc.input("1+1").input("- 6").result # -4
calc.add(7).subtract(2).result # 1

#The current result is held
calc = Calculator.new
calc.input("1+1")
calc.input("- 6")
calc.multiply_by(3)
calc.result # -12

#The last operation can be undone
calc = Calculator.new
calc.add(4).result # 4
calc.add(4).result # 8
calc.add(5).result # 13
calc.clear.result # 8

#Memory
#The calculator should implement a memory feature slightly more advanced than your standard non scienctific calacultor.
#Get memory value, if there is nothing stored in memory return nil
calc = Calculator.new
calc.get_memory # nil

#Store the current result in memory
calc.result = 10
calc.store_in_memory

#Get memory value
calc.get_memory # 10

#Perform operations on memory
calc.memory.add(10)
calc.memory.subtract(2)
calc.memory.multiple_by(3)
calc.memory.divide_by(2)
calc.get_memory # 27