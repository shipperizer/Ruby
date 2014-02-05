require 'test/unit'
require './trakio.rb'

class TestTrakio < Test::Unit::TestCase
	
	def test_instances
		Calculator.clear_instances
		calc1 = Calculator.new 
		calc2 = Calculator.new 
		assert_equal(Calculator.instances.count, 2)
	end
	
	def test_initialize_to_zero
		calc = Calculator.new
		assert_equal(calc.result, 0)
	end

	def test_result_set_at_init
		calc = Calculator.new 13
		assert_equal(calc.result, 13)
	end

	def test_result_set
		calc = Calculator.new 
		calc.result=10
		assert_equal(calc.result, 10)
	end

	def test_result_clear
		calc = Calculator.new 
		calc.result=10
		assert_equal(calc.result, 10)
		calc.clear_all
		assert_equal(calc.result, 0)
	end

	def test_is_a_i_if_whole
		calc = Calculator.new
		calc.result = 5.0
		assert(calc.result.is_a?(Integer))
	end

	def test_ops
		calc = Calculator.new(5.0)
		calc.divide_by 2
		assert_equal(calc.result, 2.5)
		calc.multiply_by(4)
		assert_equal(calc.result, 10)
		calc.add(2)
		assert_equal(calc.result, 12)
		calc.subtract(5)
		assert_equal(calc.result, 7)
	end

	def test_input
		calc = Calculator.new
		assert_equal(calc.input("1+1").result,2)
		assert_equal(calc.input("3 + 4 * 2").result,14)
		assert_equal(calc.input("6 ÷ 5").result,1.2)
	end

	def test_block_passing
		calc = Calculator.new 3
		assert_equal(calc.input do |x|
  			x**2
		end.result, 9)
	end

	def test_chained_ops
		calc = Calculator.new
		assert_equal(calc.input("1+1").input("- 6").result, -4)
		assert_equal(calc.add(7).subtract(2).result, 1)
	end

	def test_result_holding
		calc = Calculator.new
		calc.input("1+1")
		calc.input("- 6")
		calc.multiply_by(3)
		assert_equal(calc.result, -12)
	end

	def test_undo_last
		calc = Calculator.new
		calc.add(4).result # 4
		calc.add(4).result # 8
		calc.add(5).result # 13
		assert_equal(calc.clear.result, 8)
	end

	def test_memo_init
		calc = Calculator.new
		assert(calc.get_memory.nil?)
	end

	def test_memo_store
		calc = Calculator.new 10
		calc.store_in_memory
		assert_equal(calc.get_memory, 10)
	end

	def test_memo_ops
		calc = Calculator.new 10
		calc.store_in_memory
		calc.memory.add(10)
		calc.memory.subtract(2)
		calc.memory.multiply_by(3)
		calc.memory.divide_by(2)
		assert_equal(calc.get_memory, 27)
	end

	def test_memo_alias
		calc = Calculator.new 10
		calc.store_in_memory
		calc.result = 2
		calc.add_to_memory
		assert_equal(calc.get_memory, 12)
		calc.result = 10
		calc.subtract_from_memory
		assert_equal(calc.get_memory, 2)
	end

	def test_memo_namespace
		calc = Calculator.new	
		calc.result = 3
		calc.store_in_memory
		calc.result = 4
		calc.store_in_memory :a
		calc.result = 5
		calc.store_in_memory :c
		assert_equal(calc.get_memory, 3)
		assert_equal(calc.get_memory(:a), 4)
		assert_equal(calc.get_memory('c'), 5)
	end

	def test_clear_memo
		calc = Calculator.new	
		calc.result = 3
		calc.store_in_memory
		calc.result = 4
		calc.store_in_memory :a
		assert_equal(calc.get_memory, 3)
		assert_equal(calc.get_memory(:a), 4)
		calc.clear_memory
		calc.clear_memory :a
		assert_equal(calc.get_memory, nil)
		assert_equal(calc.get_memory(:a), nil)
		calc.result = 5
		calc.store_in_memory :b
		calc.store_in_memory :c
		assert_equal(calc.get_memory(:b), 5)
		assert_equal(calc.get_memory(:c), 5)
		calc.clear_all_memory		
		assert_equal(calc.get_memory(:b), nil)
		assert_equal(calc.get_memory(:c), nil)
	end

	def test_alias
		calc = Calculator.new
		calc.plus(4) 
		assert_equal(calc.result, 4)
		calc.minus(4) 
		assert_equal(calc.result, 0)
	end

	def test_inheritance
		assert_equal(4.add(4), 8)
		assert_equal(12.5.divide_by(2), 6.25)
		assert_equal(8.subtract(2), 6)
		assert_equal(3.5.multiply_by(2), 7)
		assert_equal(3.0.calculate_input("+3-2.2"), 3.8)
		assert_equal(4.calculate.add(2).result, 6)
	end

end