class Movie < ActiveRecord::Base
    def self.all_rating
        self.all.select(:rating).distinct.pluck(:rating)
    end
    
    
end
