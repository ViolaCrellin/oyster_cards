class Oystercard

  attr_reader :balance, :station_in, :journey_hist, :this_journey

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize(balance=DEFAULT_BALANCE)
    @balance = balance
    @journey_hist = []
    @this_journey = {}
  end


  def top_up(amount)
    fail "Exceeded max balance of #{MAX_BALANCE}!" if max_balance?(amount)
    @balance += amount
  end

  def touch_in(station_in)
    fail "Please top up your Oystercard" if top_up_needed?
    @station_in = station_in unless in_journey?
    this_journey[:entry] = station_in
  end

  def touch_out(station_out)
    !!station_in if in_journey?
    deduct(MINIMUM_FARE)
    @station_in = nil
    this_journey[:exit] = station_out
    @journey_hist << this_journey
    @this_journey = {}
  end

  def in_journey?
    !!station_in
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
