

class Journey

  attr_reader :this_journey, :exit_station, :entry_station

  STANDARD_FARE = 1
  PENALTY_FARE = 6

  def initialize
    @this_journey = {}
  end

  def start_journey(entry_station)
    @entry_station = entry_station
    @this_journey[:entry] = entry_station
  end


  def end_journey(exit_station)
    @exit_station = exit_station
    @this_journey[:exit] = exit_station
  end

  def completed?
    !entry_station.nil? && !exit_station.nil?
  end

  def fare
    completed? ? STANDARD_FARE : PENALTY_FARE
  end

end
