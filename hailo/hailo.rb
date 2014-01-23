#Removes any abnormal coordinates from the data set.
#Abnormal is defined - a distance between two points
#that cannot be reached without speeding over 40.


class Hailo
	attr_accessor :coordinates
	def initialize(file_path)
		@coordinates=[]
		@timestamp=[]
		arrayer file_path
	end

	def arrayer(file_path)
		a=0
		File.open(file_path, 'r') do |file|
    		file.each do |line|
      			tmp=line.split(',')
      			@coordinates[a]=[tmp[0].to_f,tmp[1].to_f]
      			@timestamp[a]=tmp[2].to_i
      			a+=1	
    		end
    	end
  	end

	def distance(pointA , pointB)
		earthRad=6371
		dLat=(pointB[0]-pointA[0])*(Math::PI/180)
		dLon=(pointB[1]-pointA[1])*(Math::PI/180)
		a= Math::sin(dLat/2) * Math::sin(dLat/2) + Math::cos(pointA[0]*Math::PI/180) * Math::cos(pointB[0]*Math::PI/180) * Math::sin(dLon/2) * Math::sin(dLon/2)
		b= 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
		return earthRad * b
	end

	def filter
		result=[]
		result<<[@coordinates[0][0],@coordinates[0][1],@timestamp[0]]
		for i in 1..@coordinates.count-1
			space=distance(@coordinates[i-1],@coordinates[i])
			time=@timestamp[i]-@timestamp[i-1]
			speed=(space/time)*3600
			#1 (metre per second) = 3.6 km per hour
			if speed < 40
				result << [@coordinates[i][0],@coordinates[i][1],@timestamp[i]]
			end
		end
		result
	end
end

test=Hailo.new('points.csv')
res=test.filter
puts res

#use of this: ruby hailo.rb > file