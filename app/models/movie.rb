class Movie < ActiveRecord::Base
    def self.collect
  	    result = []
      	self.select(:rating).uniq.each do |movie|
      		result.push(movie.rating)
      	end
      	return result
    end
end
