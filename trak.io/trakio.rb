class Calculator
	
	def initialize (init=0)
		@result= init
	end

	def result
		puts !@result.nil? && @result.to_f == @result.to_i ? @result.to_i : @result.to_f 
	end

	def result=(num)
		@result= num.to_f
	end

	def clear_all
		@result=0
	end

	def add(num)
		@result+=num.to_f
		self
	end

	def subtract(num)
		@result-=num.to_f
		self
	end

	def multipli_by (num)
		@result*=num.to_f
		self
	end

	def divide_by (num)
		@result/=num.to_f
		self
	end

	def input (expr)
		uExpr=uniformize(expr)
		puts uExpr.inspect
	 	if uExpr[:num][0].nil? 
	 		puts "Error on input";
	 		return
	 	end
	 	@result=uExpr[:num][0].to_f
	 	for i in 1..uExpr[:ops].count 
	 		case uExpr[:ops][i-1]
		 		when "+"
		 			add(uExpr[:num][i].to_f)
		 		when "-"
		 			subtract(uExpr[:num][i].to_f)
		 		when "*"
		 			multipli_by(uExpr[:num][i].to_f)
		 		when "/"
		 			divide_by(uExpr[:num][i].to_f)
		 		else
	  				puts "I have no idea what to do with that."
	  				return
			end
		end


		# for i to 1..uExpr.count
		# 	case u 

		# @result= eval(uExpr)
		self
	end


	private

	def uniformize (expr)
		uni={:ops, :num}
		uni[:num] = expr.gsub(/÷/,"/").gsub(/[×xX]/,"*").gsub("**","*").gsub(" ","").split(%r{[\/\+\-\*]}).reject {|el| el.empty? }
		uni[:ops] = expr.gsub(/÷/,"/").gsub(/[×xX]/,"*").gsub("**","*").gsub(" ","").split(%r{\d}).reject {|el| el.empty? }
		return uni
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
calc.multipli_by("4").result # 12
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