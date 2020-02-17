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
    sort = params[:sort] || session[:sort]
    if sort == 'title'
      @title_color = 'hilite'
    elsif sort == 'release_date'
      @date_color = 'hilite'
    end
    if !params.has_key?(:sort) && !params.has_key?(:ratings)
      if session.has_key?(:sort) && session.has_key?(:ratings)
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      elsif session.has_key?(:sort)
        redirect_to movies_path(:sort=>session[:sort])
      elsif(session.has_key?(:ratings))
        redirect_to movies_path(:ratings=>session[:ratings])
      end
    end
    
    if params.has_key?(:sort)
      session[:sort] = params[:sort]
    end
    @sort = session[:sort]
    @all_ratings = Movie.collect
    @ratings = params[:ratings]
    @checked = params[:ratings]||session[:ratings]||{}
    if @checked == {}
      @checked = Hash[Movie.collect.map{|rating| [rating,1]}]
    end
    if @ratings == nil
      if !params.has_key?(:commit) && !params.has_key?(:sort)
        session[:ratings] = Movie.collect
      end
    else
      session[:ratings] = @ratings
    end
    @movies = Movie.where(rating: @checked.keys).order(@sort)
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


