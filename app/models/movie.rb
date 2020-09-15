class Movie < ActiveRecord::Base
  #attr_accessible :title, :rating, :description, :release_date
  def self.all_movie_ratings
    Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
  end
end