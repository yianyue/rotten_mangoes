class MoviesController < ApplicationController

  before_action :restrict_access
  skip_before_action :restrict_access, only: [:index, :show, :search]

  def index
        
    # case params[:runtime].to_i
    # when 1
    #   range = 0..89
    # when 2
    #   range = 90..120
    # when 3
    #   range = 121..1000
    # else
    #   range = nil
    # end

    keyword = params[:keyword]
    runtime = params[:runtime] || ""
    min_runtime, max_runtime = runtime.split("-")
    
    @movies = Movie
    @movies = @movies.title_or_director_like(params[:keyword]) unless keyword.blank?

    # This feels more fragile
    @movies = @movies.runtime_less_than(max_runtime.to_i) unless max_runtime.blank?
    @movies = @movies.runtime_greater_than_or_eq_to(min_runtime.to_i) unless min_runtime.blank?

    # @movies = @movies.runtime_between(range) if range


    if keyword.present? || runtime.present?
      if @movies.any?
        flash.now.alert = "found #{@movies.size} movies"
      else
        flash.now.alert = "cannot find any movies with the given criteria"
      end
    end

    @movies = @movies.all.page(params[:page]).per(12)


  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(:title, :director, :runtime_in_minutes, :description, :poster_image_url, :release_date, :image, :remove_image)
  end

end
