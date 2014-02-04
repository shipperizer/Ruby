class Calculator
	
	def initialize (init=0)
		@result= init
	end

	def result
		puts !@result.nil? && @result == @result.to_i ? @result.to_i : @result 
	end

	def result=(num)
		@result= num
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
		@result= eval(uExpr)
		self
	end


	private

	def uniformize (expr)
		expr.gsub!(/÷/,"/")
		expr.gsub!(/[xX×]/,"*")
		expr
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
calc.input("1 - 1+1").result # 0