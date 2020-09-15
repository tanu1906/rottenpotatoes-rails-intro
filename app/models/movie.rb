class Movie < ActiveRecord::Base
    def self.all_movie_ratings
        self.all.select(:rating).distinct.pluck(:rating)
    end
end