class MoviesController < ApplicationController

  before_action :restrict_access
  skip_before_action :restrict_access, only: [:index, :show, :search]

  def index
    @movies = Movie.all
  end

  def search
    case params[:runtime].to_i
    when 0
      range = nil
    when 1
      range = 0...90
    when 2
      range = 90..120
    when 3
      range = 121..1000
      # TODO:
    end

    query = params[:query]
    query[:range] = range

    @movies = Movie.search(query)

    if @movies.any?
      flash.now.alert = "found #{@movies.size} movies"
      # why doesn't notice work here?
      render :index
    else
      redirect_to movies_path, notice: "cannot find any movies with the given criteria"
    end
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
