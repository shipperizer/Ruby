You are tasked with writing a basic non scientific calculator.

The functionality should be based around a class called Calculator and implement the follow behaviour.

Result

The current result is held, this is equivilent to the calculator's screen. There is only one result at a time.

Result is assumed to be 0

calc = Calculator.new
calc.result # 0
Result can be set at initiation

calc = Calculator.new 13
calc.result # 13
The current result can be set

calc.result = 10
calc.result # 10
The current result can be reset

calc.clear_all
calc.result # 0
The result should be returned as integer if it is a whole number otherwise a float

calc.result = 5.0
calc.result # 5
calc.divide_by 2
calc.result # 2.5
Basic operations

The current result can be added to

calc = Calculator.new
calc.add("5").result # 5
Subtracted from

calc.subtract("2").result # 3
Multiplied

calc.multiply_by("4").result # 12
Divided

calc.divide_by("3").result # 4
Input interprets an indefinatly long string of operations

calc = Calculator.new
calc.input("1+1").result # 2
calc.input("3 - 1").result # 2
calc.input("6 ÷ 5").result # 1.2
calc.input("6 / 5").result # 1.2
calc.input("3 + 4 * 2").result # 14
calc.input("3 + 4 × 2").result # 14
calc.input("1 - 1+1").result # 0
Input can also take a block for custom operations.

calc.result = 3
calc.input do |x|
  x**2
end.result # 9
Operations can be chained

calc = Calculator.new
calc.input("1+1").input("- 6").result # -4
calc.add(7).subtract(2).result # 1
The current result is held

calc = Calculator.new
calc.input("1+1")
calc.input("- 6")
calc.multiple_by(3)
calc.result # -12
The last operation can be undone

calc = Calculator.new
calc.add(4).result # 4
calc.add(4).result # 8
calc.add(5).result # 13
calc.clear.result # 8
Memory

The calculator should implement a memory feature slightly more advanced than your standard non scienctific calacultor.

Get memory value, if there is nothing stored in memory return nil

calc = Calculator.new
calc.get_memory # nil
Store the current result in memory

calc.result = 10
calc.store_in_memory
Get memory value

calc.get_memory # 10
Perform operations on memory

calc.memory.add(10)
calc.memory.subtract(2)
calc.memory.multiple_by(3)
calc.memory.divide_by(2)
calc.get_memory # 27
Add the current result to memory

calc.result = 2
calc.add_to_memory
calc.result 29
Subtract the current result from memory

calc.result = 2
calc.subtract_from_memory
calc.result 27
Allows namespace memory values distinct from the default for all of the above memory methods.

calc.result = 3
calc.store_in_memory
calc.result = 4
calc.store_in_memory :a
calc.result = 5
calc.store_in_memory :b
calc.result = 5
calc.store_in_memory :c
calc.get_memory # 3
calc.get_memory :a # 4
calc.get_memory :b # 5
calc.get_memory 'c' # 6
Can clear specific memories

calc.clear_memory
calc.clear_memory :a
calc.get_memory # nil
calc.get_memory :a # nil
Can clear all memory

calc.clear_all_memory
calc.get_memory :b # nil
calc.get_memory :c # nil
Alias

The following methods should alias respectively

calc.plus(4) # equivilent to calc.add(4)
calc.minus(4) # equivilent to calc.subtract(4)
Add additional functionality in Ruby's native Float and Integer classes

Add operators, these should return integers if integers otherwise floats.

4.add(4) # 8
12.5.divide_by(2) # 6.25
8.subtract(2) # 6
3.5.multiply_by(2) # 7
3.calculate_input("+3-2.2") # 3.8
Add a calculate method to return a new Calculator instance with the result already set.

4.calculate.add(2).result # 6
Keeping track

The Calculator class should keep track of all instances

calc1 = Calculator.new calc2 = Calculator.new Calculator.instances # [calc1, calc2]

Tests

Its up to you to choose in what way and how many tests you should implement. 100% test coverage isn't required just enough to demonstrate a knowledge of TDD/BDD. You will get bonus points for using rspec and writing complete (or near complete) test coverage though.

Restrictions

You may only use the following operators/methods once each in your code:
*
\
+
-
send or call (ie once for either)
Bonus points

Setting the code base up as a Gem - uploading to Ruby Gems is not required.
Using rspec to test with complete (or near to complete) coverage.
Outline in a README.md any short comings in the proposed specification above.