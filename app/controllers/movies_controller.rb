class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @movies = Movie.all
    @all_ratings = Movie.all_movie_ratings   #put all the unique ratings into this instance variable
    
    # filter  movies based on ratings checked on check box
    if params[:ratings] 
      @marked_ratings = params[:ratings]
    else
      @marked_ratings = Hash[@all_ratings.collect {|rating| [rating, rating]}]
    end
    
    @movies = Movie.where(rating: @marked_ratings.keys)
   
    #sorting by movie title or release date
   
    @sort_movie = params[:sort_by] if params[:sort_by]
    
    if @sort_movie == 'title'
      @movies = @movies.order(@sort_movie)
    elsif @sort_movie == 'release_date'
      @movies = @movies.order(@sort_movie)
    end

    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
