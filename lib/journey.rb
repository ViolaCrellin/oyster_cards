

class Journey

  attr_reader :this_journey, :exit_station, :entry_station

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
    !!entry_station && !!exit_station
  end

end
