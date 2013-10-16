require 'yaml'

vending_data = {
				:products => [
					[1,"Milk","0.30",50],
					[2,"Coffee","0.35",50],
					[3,"Cappuccino","0.45",50],
					[4,"Muffin","1.03",50]
				]
			   }

puts vending_data.to_yaml
# Write the YAML data to file
f = File.open("products", "w+")
f.puts vending_data.to_yaml
f.close
