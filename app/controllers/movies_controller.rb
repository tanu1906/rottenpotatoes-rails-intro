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
   
    @all_ratings = Movie.all_movie_ratings #stores all the unique ratings of movies

    #check and store user input to sort, and if remembered values not nil then store the remebered value for further use.
    if params[:sort_by] 
       @sort_movie = params[:sort_by]
    elsif session[:sort_by] 
       @sort_movie = session[:sort_by]
    end

    #check and store user input for selected ratings or remebered ratings or all
    if(params[:ratings])
      @marked_ratings = params[:ratings]
    elsif(session[:ratings])
      @marked_ratings = session[:ratings]
    else
      @marked_ratings = Hash[@all_ratings.collect {|rating| [rating, rating]}]
    end

   # When user switches to other page
    if params[:sort_by]!=session[:sort_by] or params[:ratings]!=session[:ratings]
      session[:sort_by] = @sort_movie
      session[:ratings] = @marked_ratings
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by],ratings: session[:ratings])
    end	 
    
    @movies = Movie.where(rating: @marked_ratings.keys)
    
    # Sorting based on the user input 
   
    if(@sort_movie == 'title')
      @movies = @movies.order(@sort_movie)
    elsif (@sort_movie == 'release_date')
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
