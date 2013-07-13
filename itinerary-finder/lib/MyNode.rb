class MyNode
  #Attributes
  attr_accessor :event_time, :station_num, :station_name, :original_event_time, :node_id

  def initialize node_id, event_time, station_num, station_name, original_event_time
    @node_id = node_id
    @event_time = event_time
    @station_num = station_num
    @station_name = station_name
    @original_event_time = original_event_time
  end

end