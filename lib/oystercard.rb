class Oystercard

  attr_reader :balance, :journey_hist, :current_trip, :entry_station #entry station won't be needed later

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MINIMUM_BALANCE = 1
  PENALTY_FARE = 6


  def initialize(journey_hist=JourneyLog.new, balance=DEFAULT_BALANCE)
    @balance = balance
    @journey_hist = journey_hist
  end


  def top_up(amount)
    fail "Exceeded max balance of #{MAX_BALANCE}!" if max_balance?(amount)
    @balance += amount
  end

  def show_journeys
    @journey_hist.history
  end

  def touch_in(station_in)
    fail "Please top up your Oystercard" if top_up_needed?
    # unless entry_station.nil?
      #OUTSOURCED later with edge cases
      # deduct(PENALTY_FARE)
      #OUTSOURCED TO LOG
      # @journey_hist << current_trip.this_journey
    # end
    #OUTSOURCED to LOG
    # @current_trip = @journey_klass.new

    @journey_hist.start_journey(station_in)
    #OUTSOURCED TO LOG
    # @entry_station = station_in
  end

  def touch_out(station_out)
    #OUSOURCED TO LOG
    if entry_station.nil?
      #OUTSOURCED TO LOG
      # @current_trip = @journey_klass.new
    end
      @journey_hist.end_journey(station_out)
      deduct(@journey_hist.fare)
      #OUTSOURCED to LOG
      # @journey_hist << current_trip.this_journey
      #OUTSOURCED TO LOG
      # @entry_station = nil
  end



private

  def max_balance?(amount)
    balance + amount > MAX_BALANCE
  end

  def deduct(fare)
    @balance -= fare
  end

  def top_up_needed?
    @balance <= MINIMUM_BALANCE
  end

end
