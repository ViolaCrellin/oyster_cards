require 'oystercard'
require 'station'
require 'journey'

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
    card.top_up 1
    expect{card.touch_in(:Peckham)}.to raise_error("Please top up your Oystercard")
  end

  it 'deducts money from oystercard when touching out' do
    card = Oystercard.new
    card.top_up 20
    card.touch_in(:Peckham)
    card.touch_out(:Aldgate)
    expect(card.balance).to eq 19
  end

  it 'lets you retrieve the name of the station you touched in at' do
    card = Oystercard.new
    card.top_up 20
    card.touch_in("Peckham")
    expect(card.entry_station).to eq "Peckham"
  end

  it 'saves one journey history' do
    card = Oystercard.new
    card.top_up 20
    card.touch_in "Peckham"
    card.touch_out "Aldgate"
    expect(card.journey_hist).to include ({entry: "Peckham", exit: "Aldgate"})
  end

  it 'saves an incomplete journey in #history when you touch in twice' do
    card = Oystercard.new
    card.top_up 20
    card.touch_in "Peckham"
    card.touch_in "Shoreditch"
    expect(card.journey_hist).to include ({entry: "Peckham"})
  end

  it 'saves an incomplete journey in #history when you touch out but don\'t touch in.' do
    card = Oystercard.new
    card.top_up 20
    card.touch_out "Peckham"
    expect(card.journey_hist).to include ({exit: "Peckham"})
  end

  it 'deducts penalty fare when you touch out but don\'t touch in' do
    card = Oystercard.new
    card.top_up 20
    card.touch_out "Peckham"
    expect(card.balance).to eq 14
  end

  it 'deducts penalty fare when you touch in but don\'t touch out' do
    card = Oystercard.new
    card.top_up 20
    card.touch_in "Peckham"
    card.touch_in "Shoreditch"
    expect(card.balance).to eq 14
  end

  it 'deducts standard fare when you both touch in and touch out' do
    card = Oystercard.new
    card.top_up 20
    card.touch_in "Peckham"
    card.touch_out "Shoreditch"
    expect(card.balance).to eq 19
  end


end
