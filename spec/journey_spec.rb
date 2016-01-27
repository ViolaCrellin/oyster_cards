require 'journey'

describe Journey do

  subject(:journey) {described_class.new}

  it {is_expected.to respond_to(:in_journey?)}
  it {is_expected.to respond_to(:start_journey)}
  it {is_expected.to respond_to(:end_journey)}

  it 'has an empty hash to save current journey' do
    expect(journey.this_journey).to eq ({})
  end

  context 'keeping track of journey state' do

    before do
      let(:station1) {double :station}
      let(:station2) {double :station}
      journey.start_journey station
      journey.end_journey station2
    end

    it 'is able to store and retrieve starting station' do
      expect(journey.entry_station).to eq station1
    end

    it 'is able to store and retrieve exit station' do
      expect(journey.exit_station).to eq station2
    end


  end

end
