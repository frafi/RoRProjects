class ItineraryController < ApplicationController
  # GET /itinerary
  # GET /itinerary.json

  # GET /train_routes/1
  # GET /train_routes/1.json
  def show
    start_station = params[:start_station]
    end_station = params[:end_station]
    reach_by = params[:reach_by]
    #ToDo: Protect against SQL injection
    @itinerary = Itinerary.new start_station, end_station, reach_by
    @itinerary.compute_trip
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @itinerary }
    end
  end  
end
