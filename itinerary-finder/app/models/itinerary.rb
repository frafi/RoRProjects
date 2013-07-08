class Itinerary
  #Attributes
  attr_accessor :start_station, :end_station, :reach_by
  
  def initialize start, destination, reach
    @start_station = start
    @end_station = destination
    @reach_by = reach
  end
  
  def generate_nodes
    #ToDo: Generate all the nodes
  end
  
  def generate_arcs
    #ToDo: Generate all the arcs
  end
  
  def compute_trip
    # Check if nodes and arcs have already been generated
    generate_nodes if Node.all.empty? 
    generate_arcs if Arc.all.empty?
    
    #ToDo: Run the algorithm    
  end
end
    