require_relative 'journey_log'

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
    if @journey_hist.trip.nil?
      @journey_hist.start_journey(station_in)
    else
      touch_out(nil)
      # deduct(@journey_hist.trip.fare)
    end
  end

  def touch_out(station_out)
    if @journey_hist.trip.nil?
      @journey_hist.start_journey
      @journey_hist.end_journey(station_out)
      deduct(@journey_hist.outstanding_charges)
      @journey_hist.reset
    else
      @journey_hist.end_journey(station_out)
      deduct(@journey_hist.outstanding_charges)
      @journey_hist.reset
    end
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

  # def reimburse
  #   amount = PENALTY_FARE - @journey_hist.outstanding_charges
  #   @balance += amount
  # end

end
