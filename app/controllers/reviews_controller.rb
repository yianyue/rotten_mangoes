class ReviewsController < ApplicationController

  before_filter :restrict_access, :load_movie
  
  def new
    @review = @movie.reviews.build
  end

  def create
    @review = @movie.reviews.build(review_params)
    @review.user_id = current_user.id
    
    if @review.save
      redirect_to movie_path(@movie), notice: "Review was submitted successfully!"
    else
      render :new
    end
  end

  protected

  def review_params
    params.require(:review).permit(:text, :rating_out_of_ten)
  end

  def load_movie
    @movie = Movie.find(params[:movie_id])
  end

end
