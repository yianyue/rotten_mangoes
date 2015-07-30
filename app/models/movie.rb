class Movie < ActiveRecord::Base

  has_many :reviews

  mount_uploader :image, ImageUploader

  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }

  validate :release_date_is_in_the_future

  scope :title_or_director_like, -> (keyword){ where("title LIKE ? OR director LIKE ?", "%#{keyword}%", "%#{keyword}%") }
  scope :runtime_between, -> (range) { where(runtime_in_minutes: range) }
  
  scope :runtime_less_than, -> (max){ where("runtime_in_minutes < ?", max) }
  scope :runtime_greater_than_or_eq_to, -> (min){ where("runtime_in_minutes >= ?", min) }

  def review_average
    if self.reviews.any?
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      return 0
    end
  end

  # def self.search(query) 
  #   movies = self.where("lower(title) LIKE ? OR lower(director) LIKE ?", "%#{query[:keyword]}%", "%#{query[:keyword]}%")
  #   movies = movies.where(runtime_in_minutes: query[:range]) if query[:range]
  #   return movies
  # end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end  
  
end