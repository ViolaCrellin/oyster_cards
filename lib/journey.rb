

class Journey

  attr_reader :this_journey, :exit_station, :entry_station

  STANDARD_FARE = 1
  PENALTY_FARE = 6

  def initialize(entry_station)
    @this_journey = {}
    @entry_station = entry_station
    @this_journey[:entry] = @entry_station.name
  end



  def finish(exit_station)
    @exit_station = exit_station
    @this_journey[:exit] = @exit_station.name
  end

  def completed?
    !entry_station.nil? && !exit_station.nil?
  end

  def zone_fare
    (@entry_station.zone - @exit_station.zone).abs + 1
  end


  def fare
    completed? ? zone_fare : PENALTY_FARE
  end

end
