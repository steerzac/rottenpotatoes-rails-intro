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
    @all_ratings = Movie.ratings
    @hilite = {:title => false, :rating => false, :release_date => false}
    @checked = {}
    
    # Begin with all movies
    @movies = Movie.all
    
    # Filter out those by ratings
    if params[:ratings] then
      @movies = @movies.where(:rating => params[:ratings].keys)
      params[:ratings].keys.each do |rating|
        @checked[rating] = true
      end
    else
      @all_ratings.each do |rating|
        @checked[rating] = true
      end
    end 
    
    # Sort remaining movies by column
    if params[:sort_by] == "Movie Title" then
      @movies = @movies.order(:title)
      @hilite[:title] = true
    elsif params[:sort_by] == "Rating" then
      @movies = @movies.order(:rating)
      @hilite[:rating] = true
    elsif params[:sort_by] == "Release Date" then
      @movies = @movies.order(:release_date)
      @hilite[:release_date] = true
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
