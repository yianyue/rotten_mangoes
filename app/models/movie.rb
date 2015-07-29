class Movie < ActiveRecord::Base

  has_many :reviews

  mount_uploader :image, ImageUploader

  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }

  validate :release_date_is_in_the_future

  def self.search(query) 
    movies = self.where("lower(title) LIKE ?", "%#{query[:title]}%").where("lower(director) LIKE ?", "%#{query[:director]}%")
    movies = self.where(runtime_in_minutes: query[:range]) if query[:range]
    return movies
  end

  def review_average
    if self.reviews.any?
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      return 0
    end
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end  
  
end