require 'journey'

describe Journey do
  let(:station1) {double :station}
  let(:station2) {double :station}
  subject(:journey) {described_class.new station1}

  describe "#initialize" do

    before do
      allow(station1).to receive(:name).and_return("Station Name 1")
    end


    it 'creates and stores an entry_station name' do
      expect(journey.entry_station).to eq (station1)
    end

    it 'creates an hash called this_journey' do
      expect(journey.this_journey).to eq ({entry: "Station Name 1"})
    end

  end

  describe "#start_journey" do

    before do
      allow(station1).to receive(:name).and_return("Station Name 1")
      allow(station2).to receive(:name).and_return("Station Name 2")
      # journey.start_journey station1
      journey.finish station2
    end

    # it {is_expected.to respond_to(:start_journey).with(1).argument}

    # it 'is able to store and retrieve starting station' do
    #   expect(journey.entry_station).to eq station1
    # end


  describe "#finish" do


    it {is_expected.to respond_to(:finish).with(1).argument}

    it 'is able to store and retrieve finish station' do
        expect(journey.exit_station).to eq station2
    end

  end
end


  describe "#completed?" do

    it {is_expected.to respond_to(:completed?)}

    before do
      allow(station1).to receive(:name).and_return("Station Name 1")
      allow(station2).to receive(:name).and_return("Station Name 2")
      # journey.start_journey station1
    end

    it "returns not completed when either finish station or entry station is nil" do
      expect(journey.completed?).to be false
    end


    it "returns true when there is an exit station and an exit station" do
      journey.finish station2
      expect(journey.completed?).to be true
    end

  end

  describe '#this_journey' do
    let(:this_journey) { {entry: "Station Name 1", exit: "Station Name 2"}}


    before do
      allow(station1).to receive(:name).and_return("Station Name 1")
      allow(station2).to receive(:name).and_return("Station Name 2")
      # journey.start_journey station1
      journey.finish station2
    end

    it 'returns a hash of the journey upon journey end' do
      expect(journey.this_journey).to eq this_journey
    end
  end

  describe '#zone_fare' do
    let(:random_zone1) {rand(1..5)}
    let(:random_zone2) {rand(1..5)}

    before do
      allow(station1).to receive(:name).and_return("Station Name 1")
      allow(station2).to receive(:name).and_return("Station Name 2")
      allow(station1).to receive(:zone).and_return(random_zone1)
      allow(station2).to receive(:zone).and_return(random_zone2)
      # journey.start_journey station1
    end

      it {is_expected.to respond_to(:zone_fare)}

      it 'calculates fare based on station\'s zone' do
        journey.finish station2
        expect(journey.zone_fare).to eq ((random_zone1 - random_zone2).abs + 1)
      end



    describe '#fare' do

      it {is_expected.to respond_to(:fare)}

      context '#fare returns penalty fare' do

        it 'returns penalty fare of 6 when #completed? is false' do
          # journey.start_journey station1
          expect(journey.fare).to eq Journey::PENALTY_FARE
        end

      end

    end
  end
end
