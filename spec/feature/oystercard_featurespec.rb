require 'oystercard'

describe 'feature_test' do

  it 'Tops up oystercard' do
    card = Oystercard.new
    expect(card.top_up 20).to eq card.balance
  end

  it 'Stops you putting too much money on your card' do
    card = Oystercard.new
    expect{card.top_up(91)}.to raise_error("Exceeded max balance of #{Oystercard::MAX_BALANCE}!")
  end

  it 'Stops you touching in if you don\'t have enough money on your card.' do
    card = Oystercard.new
    station_in = :Peckham
    card.top_up 1
    expect{card.touch_in(station_in)}.to raise_error("Please top up your Oystercard")
  end

  it 'deducts money from oystercard when touching out' do
    card = Oystercard.new
    station_in = :Peckham
    card.top_up 20
    card.touch_in(station_in)
    card.touch_out
    expect(card.balance).to eq 19
  end

  it 'lets you retrieve the name of the station you touched in at' do
    card = Oystercard.new
    station_in = :Peckham
    card.top_up 20
    card.touch_in(station_in)
    expect(card.station_in).to eq station_in
  end

  it 'saves one journey history' do
    card = Oystercard.new
    station_in = :Peckham
    station_out = :Aldgate
    card.touch_in(station_in)
    card.touch_out(station_out)
    expect()

end
