require 'oystercard'

describe Oystercard do
  let(:dummy_journey) {double :dummy_journey}
  subject(:oystercard) {described_class.new}
  let(:topup_amount) {5}
  let(:random_topup_amount) {rand(1..20)}
  let(:too_large_topup) {91}
  let(:station_in) { double :station}
  let(:station_out) { double :station}
  let(:standard_fare) {1}

  describe "#initialize" do

    it {is_expected.to respond_to(:balance)}

    it "has an initial balance of 0" do
      expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
    end

    it 'has an empty list of journeys by default' do
      expect(oystercard.journey_hist).to eq []
    end

  end

  describe "#top_up" do

    it {is_expected.to respond_to(:top_up).with(1).argument}

    it "Adds set top-up amount to balance" do
      expect(oystercard.top_up(topup_amount)).to eq (oystercard.balance)
    end

    it "Adds random top-up amount to balance" do
      expect(oystercard.top_up(random_topup_amount)).to eq (oystercard.balance)
    end

      context "top up with max balance" do

        it "raises error if max balance is exceeded" do
          expect{oystercard.top_up(too_large_topup)}.to raise_error "Exceeded max balance of #{Oystercard::MAX_BALANCE}!"
        end

      end

    end

  describe "#touch_in" do

    before do

      oystercard.top_up(topup_amount)
    end


    context "Cannot have less than £#{Oystercard::MINIMUM_BALANCE}" do

      subject(:poor_oystercard) {Oystercard.new(1)}

      it "Will raise error 'Please top up your Oystercard'" do
        expect {poor_oystercard.touch_in(station_in, dummy_journey)}.to raise_error "Please top up your Oystercard"
      end

    end

  end




  describe "#touch out" do

    context "Changing card status to be not #in_journey?" do

      before do
        allow(dummy_journey).to receive(:new).and_return dummy_journey
        allow(dummy_journey).to receive(:start_journey).with(station_in)
        allow(dummy_journey).to receive(:end_journey).with(station_out)
        allow(dummy_journey).to receive(:fare).and_return standard_fare
        allow(dummy_journey).to receive(:this_journey) {{entry: station_in, exit: station_out}}
        oystercard.top_up(topup_amount)
        oystercard.touch_in(station_in, dummy_journey)
      end


      it "deducts fare when touched out" do
        expect {oystercard.touch_out(station_out)}.to change(oystercard, :balance).by(-standard_fare)
      end

      it "deducts penalty"

    end


    context "#touch_out will save journey history and reset this_journey" do

      let(:completed_journey) { {entry: station_in, exit: station_out}}


      before do
        oystercard.top_up 10
        oystercard.touch_in(station_in)
        oystercard.touch_out(station_out)
      end

      it 'saves one journey after touching in and out to journey_hist' do
        expect(oystercard.journey_hist).to include completed_journey
      end

    end

  end
end
