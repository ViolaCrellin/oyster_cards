class Oystercard

  attr_reader :balance, :entry_station, :journey_hist, :this_journey, :current_trip

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MINIMUM_BALANCE = 1
  PENALTY_FARE = 6


  def initialize(journey_klass=Journey, balance=DEFAULT_BALANCE)
    @balance = balance
    @journey_hist = []
    @journey_klass = journey_klass
  end


  def top_up(amount)
    fail "Exceeded max balance of #{MAX_BALANCE}!" if max_balance?(amount)
    @balance += amount
  end

  def touch_in(station_in)
    fail "Please top up your Oystercard" if top_up_needed?
    unless entry_station.nil?
      deduct(PENALTY_FARE)
      @journey_hist << current_trip.this_journey
    end
    @entry_station = station_in
    @current_trip = @journey_klass.new
    current_trip.start_journey(station_in)
  end

  def touch_out(station_out)
    if entry_station.nil?
      @current_trip = @journey_klass.new
    end
      current_trip.end_journey(station_out)
      deduct(current_trip.fare)
      @journey_hist << current_trip.this_journey
      @entry_station = nil
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
