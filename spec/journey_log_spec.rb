
require './lib/journey_log.rb'

describe JourneyLog do
  let(:dummy_journey_klass) {double :dummy_journey_klass}
  let(:dummy_journey) {double :dummy_journey}
  subject(:log) {described_class.new dummy_journey_klass}
  let(:entry_station) {double :entry_station}
  let(:exit_station) {double :exit_station}


  before do
  allow(dummy_journey_klass).to receive(:new).and_return dummy_journey
  allow(dummy_journey).to receive(:fare)
  allow(dummy_journey).to receive(:finish)
  allow(dummy_journey).to receive(:outstanding_charges)
  end

  describe '#initialize' do


    it {is_expected.to respond_to(:history)}

    it 'is initialized with an empty array' do
      expect(log.history).to be_empty
    end

  end

  describe '#journeys' do

    it {is_expected.to respond_to(:journeys)}

  end

  describe '#start_journey' do

      it {is_expected.to respond_to(:start_journey).with(1).argument}

  end

  describe '#end_journey' do

    it {is_expected.to respond_to(:end_journey).with(1).argument}

  end

  describe  '#trip' do

    it 'will allow log to receive #finish' do
        log.start_journey(entry_station)
        expect(dummy_journey).to receive(:finish).with(exit_station)
        log.end_journey(exit_station)
    end

  end

  describe '#create_trip' do

    it {is_expected.to respond_to(:create_trip).with(1).argument}

    it '#creates a new trip' do
      expect(dummy_journey_klass).to receive(:new).with(entry_station)
      log.create_trip(entry_station)
    end

  end

  describe '#outstanding_charges' do


    it 'will fetch the fare from Journey class' do
      log.start_journey(entry_station)
      log.end_journey(exit_station)
      expect(dummy_journey).to receive(:fare)
      log.outstanding_charges
    end

  end


  describe '#add_to_history' do

    it {is_expected.to respond_to(:add_to_history)}

    it 'will add the trip to the history' do
      log.start_journey(entry_station)
      expect(log.history).to include dummy_journey
    end

  end


end
