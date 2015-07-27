class Review < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :movie

  validates :text, :user, :movie, presence: true
  validates :rating_out_of_ten, numericality: { only_integer: true, greater_than: 0, less_than: 11 }

end
