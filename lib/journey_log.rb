require_relative 'journey'

class JourneyLog

#This class will mediate between Journey and Oystercard
attr_reader :history, :trip

  def initialize(journey_klass=Journey)
    @journey_klass = journey_klass
    @history = []
    @trip = nil
  end

  def journeys
    @history.dup
  end


  def start_journey(station_in=nil)
    add_to_history(create_trip(station_in))
  end


  def end_journey(station_out=nil)
    @trip.finish(station_out)
  end


  def create_trip(station_in)
    @trip = @journey_klass.new(station_in)
  end


  def completed_trip?
    @trip.completed?
  end

  def reset
    @trip = nil
  end

  def outstanding_charges
    @trip.fare
  end

  def add_to_history(trip)
    @history << trip
  end


end
