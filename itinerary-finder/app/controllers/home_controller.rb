class HomeController < ApplicationController
  def index
  end

  def create_nodes
    # First empty all nodes
    Node.delete_all
  end
  
  def create_arcs
    # First empty all nodes
    Arc.delete_all
  end

  def show_itinerary
    begin
      start_station_num = params[:start_station]
      end_station_num = params[:end_station]
      reach_by_hhhmm = params[:reach_by]
    
      #logger.debug params[:start_station][:station_num] unless params[:start_station].nil?
    
      create_nodes if Node.all.empty?
    
      create_arcs if Arc.all.empty?
    
      respond_to do |format|
        format.html # show_itinerary.html.erb
        #format.json { render json: @node }
      end
    #@node = Node.find(params[:id])
    
      #logger.debug params.inspect
      #start_station = params[:start_station]
      #end_station = params[:end_station]
      #reach_by = params[:reach_by]
      #ToDo: Protect against SQL injection
      #@itinerary = Itinerary.new start_station, end_station, reach_by
      #@itinerary.compute_trip
      
      #respond_to do |format|
      #  format.html # show.html.erb
      #  format.json { render json: @itinerary }
      #end
    rescue
      #ToDo: Set error message    
    ensure
      #ToDo: Set default itinerary
    end
  end  
end
