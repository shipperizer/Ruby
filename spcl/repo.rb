# The purpose of this exercise is to use the Github public API to find a given list of users’ total number of public commits 
# over the past year and rank them accordingly.
# The program will take a comma-separated list of Github usernames from standard input, make the relevant calls to the Github
# API then present the results in a list of username -> commit mappings, ordered by commit counts. Note that for each repo, 
# we’re interested in just the owner’s commits, not the commits of everybody with access to the repo.
# Feel free to use any third party libraries you like.

require 'net/http'
require 'json'

class Github
	def stats usernames
		token='3e7d8a02e52c5a4232e81c71a0d75874ff688946'
		result = []

		usernames.each do |user|
			n_commits=0
			uri = URI("https://api.github.com/users/#{user}/repos")
			params = { :access_token => token }
			uri.query = URI.encode_www_form(params)
			Net::HTTP.start(uri.host, uri.port,	:use_ssl => uri.scheme == 'https') do |http|
		  		request = Net::HTTP::Get.new uri
		  		response = http.request request # Net::HTTPResponse object
		  		jsonData = response.body.to_s.gsub(/[\[\]]/,'').gsub(/},{/,'}**##**{').split('**##**')
		  		if jsonData != "" then 
		  			jsonData.each do |repo|
			  			repoData = JSON.parse(repo)
			  			uri_l1 = URI("https://api.github.com/repos/#{user}/#{repoData['name']}/stats/participation")
			  			uri_l1.query = URI.encode_www_form(params)
						Net::HTTP.start(uri_l1.host, uri_l1.port,	:use_ssl => uri_l1.scheme == 'https') do |http_l1|
			  				request_l1 = Net::HTTP::Get.new uri_l1
			  				response_l1 = http.request request_l1 # Net::HTTPResponse object
			  				commit = JSON.parse(response_l1.body)
			  				if commit['message'] !="Not Found" && commit != "[]" && commit != {} && commit !="" then
				  				n_commits+= commit['owner'].inject{|sum,val| sum+val}
				  			end
			  			end
			  		end
			  	end
		  	end
  			result << { name: user, commits: n_commits}
  		end
  		puts "\nResults:"
  		display = result.sort_by {|i| i[:commits]}
  		display.reverse.each do |entry|
  			puts "#{entry[:name]} - #{entry[:commits]}"
  		end
  	end
end

puts "Enter github usernames:"
users = gets.chomp.gsub(" ","").split(',')
Github.new.stats users 
