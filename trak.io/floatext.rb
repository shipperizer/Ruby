class Float
	def add(num)
		self + num
	end
end

puts 4.0.add(3)

class Abc
	@@num=[]
	def initialize
		@@num << self
	end

	def self.num
		@@num
	end
end

a=Abc.new
b=Abc.new
puts "this is #{Abc.num}"