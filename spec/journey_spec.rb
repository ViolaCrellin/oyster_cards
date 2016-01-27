require 'journey'

describe Journey do

  subject(:journey) {described_class.new}
  let(:station1) {double :station}
  let(:station2) {double :station}

  describe "#initialize" do

    it 'has an empty hash to save current journey' do
      expect(journey.this_journey).to eq ({})
    end

  end

  describe "#start_journey" do

    before do
      journey.start_journey station1
      journey.end_journey station2
    end

    it {is_expected.to respond_to(:start_journey).with(1).argument}

    it 'is able to store and retrieve starting station' do
      expect(journey.entry_station).to eq station1
    end


  describe "#end_journey" do

    it {is_expected.to respond_to(:end_journey).with(1).argument}

    it 'is able to store and retrieve exit station' do
        expect(journey.exit_station).to eq station2
    end

  end
end

  describe "#completed?" do

    it {is_expected.to respond_to(:completed?)}

    before {journey.start_journey station1}

    it "returns not completed when either exit station or entry station is nil" do
      expect(journey.completed?).to be false
    end


    it "returns true when there is an exit station and an exit station" do
      journey.end_journey station2
      expect(journey.completed?).to be true
    end

  end

  describe '#this_journey' do

    before do
      journey.start_journey station1
      journey.end_journey station2
    end

    it 'returns a hash of the journey upon journey end' do
      expect(journey.this_journey).to include station1, station2
    end

  end

end
