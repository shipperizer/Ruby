#Removes any abnormal coordinates from the data set.
#Abnormal is defined - a distance between two points
#that cannot be reached without speeding over 40.

class GeoPoint 

	def initialize(latitude, longitude, timestamp)
		@latitude = latitude.to_f
		@longitude = longitude.to_f
		@timestamp = timestamp.to_i
	end

	def getLat
		@latitude		
	end

	def getLong
		@longitude
	end

	def getTime
		@timestamp
	end
end

class Path

	@@earthRad=6371

	def initialize
		@path=[]
	end

	def add(geoPoint)
		@path << geoPoint
	end

	def filter(speedlimit)
		puts "before filtering #{@path.count} \n #{@path.inspect}"
		redundant=[]
		for i in 1..@path.count-1
			space = distance(@path[i-1],@path[i])
			time=@path[i].getTime-@path[i-1].getTime
			speed=(space/time)*3600
			#1 (metre per second) = 3.6 km per hour
			if speed > speedlimit
				redundant << i
			end
		end
		
		redundant.each do |i|
			@path[i]=nil
		end 
		@path.compact!		
		
		puts "after filtering #{@path.count} \n #{@path.inspect}"
	end

	private

	def distance(pointA , pointB)
		dLat=(pointB.getLat-pointA.getLat)*(Math::PI/180)
		dLon=(pointB.getLong-pointA.getLong)*(Math::PI/180)
		a= Math::sin(dLat/2) * Math::sin(dLat/2) + Math::cos(pointA.getLat*Math::PI/180) * Math::cos(pointB.getLat*Math::PI/180) * Math::sin(dLon/2) * Math::sin(dLon/2)
		b= 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
		return @@earthRad * b
	end
end



class Hailo
	
	def initialize(file_path='points.csv')
		@path=Path.new
		arrayer file_path
	end

	def arrayer(file_path)
		File.open(file_path, 'r') do |file|
    		file.each do |line|
      			tmp=line.split(',')
      			@path.add(GeoPoint.new(tmp[0],tmp[1],tmp[2]))
      		end
    	end    	
  	end

	def filter(speedlimit=30)
		@path.filter(speedlimit)
		@path
	end
end

test=Hailo.new(ARGV[0])
res=test.filter
puts "MAIN after filtering \n #{res.inspect}"

#use of this: ruby hailo.rb > file
