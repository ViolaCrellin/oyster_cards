require 'oystercard'
require 'station'
require 'journey'

xdescribe 'feature_test' do

    let(:card) {Oystercard.new}
    let(:random_zone1) {rand(1..5)}
    let(:random_zone2) {rand(1..5)}
    let(:station1) {Station.new("Station Name 1", random_zone1)}
    let(:station2) {Station.new("Station Name 2", random_zone2)}

context 'Brand new card' do

    it 'Stops you touching in if you don\'t have enough money on your card.' do
      expect{card.touch_in(station1)}.to raise_error("Please top up your Oystercard")
    end

  it 'Tops up oystercard' do
    expect(card.top_up 20).to eq card.balance
  end

  it 'Stops you putting too much money on your card' do
    expect{card.top_up(91)}.to raise_error("Exceeded max balance of #{Oystercard::MAX_BALANCE}!")
  end
end

context 'Fares and journey logging' do

    before do
      card.top_up 20
    end

    it 'deducts money from oystercard when touching out' do
      card.touch_in(station1)
      expect {card.touch_out(station2)}.to change(card, :balance).by(-((random_zone1 - random_zone2).abs + 1))
    end

    it 'lets you retrieve the name of the station you touched in at' do
      card.touch_in(station1)
      expect(card.entry_station.name).to eq "Station Name 1"
    end

    it 'saves one journey history' do
      card.touch_in(station1)
      card.touch_out(station2)
      expect(card.journey_hist).to include ({entry: "Station Name 1", exit: "Station Name 2"})
    end

    it 'saves an incomplete journey in #history when you touch in twice' do

      card.touch_in(station1)
      card.touch_in(station2)
      expect(card.journey_hist).to include ({entry: "Station Name 1"})
    end

    it 'saves an incomplete journey in #history when you touch out but don\'t touch in.' do

      card.touch_out(station1)
      expect(card.journey_hist).to include ({exit: "Station Name 1"})
    end

    it 'deducts penalty fare when you touch out but don\'t touch in' do

      card.touch_out(station1)
      expect(card.balance).to eq 14
    end

    it 'deducts penalty fare when you touch in but don\'t touch out' do

      card.touch_in(station1)
      card.touch_in(station2)
      expect(card.balance).to eq 14
    end
  end

end
