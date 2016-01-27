require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:topup_amount) {5}
  let(:random_topup_amount) {rand(1..20)}
  let(:too_large_topup) {91}
  let(:station_in) { double :station}
  let(:station_out) { double :station}

  describe "#initialize" do

    it {is_expected.to respond_to(:balance)}

    it "has an initial balance of 0" do
      expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
    end

    it {is_expected.to respond_to(:in_journey?)}

    it 'has an empty list of journeys by default' do
      expect(oystercard.journey_hist).to eq []
    end

    it 'has an empty hash to save current journey' do
      expect(oystercard.this_journey).to eq ({})
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

    it "returns true to #in_journey when you touch in" do
      expect {oystercard.touch_in(station_in)}.to change(oystercard, :in_journey?).from(false).to(true)
    end

    it "returns true when in_journey?" do
      oystercard.touch_in(station_in)
      expect(oystercard.in_journey?).to be_truthy
    end

    context "Cannot have less than £#{Oystercard::MINIMUM_BALANCE}" do

      before do
        4.times do
          oystercard.touch_in(station_in)
          oystercard.touch_out(station_out)
        end
      end

      it "Will raise error 'Please top up your Oystercard'" do
        expect {oystercard.touch_in(station_in)}.to raise_error "Please top up your Oystercard"
      end

    end

    context "#touch_in remembers the station you touched in at" do

      it "Will return name of station touched in at" do
        expect(oystercard.touch_in(station_in)).to eq station_in
      end

      it "Will let you store the name of the station you touched in at" do
        oystercard.touch_in(station_in)
        expect(oystercard.station_in).to eq station_in
      end

    end

  end

  describe "#touch out" do

    context "Changing card status to be not #in_journey?" do

      before do
        oystercard.top_up(topup_amount)
        oystercard.touch_in(station_in)
      end

      it "returns false to #in_journey? when you touch in" do
        expect {oystercard.touch_out(station_out)}.to change(oystercard, :in_journey?).from(true).to(false)
      end

      it "return false when touched out" do
        oystercard.touch_out(station_out)
        expect(oystercard.in_journey?).to be_falsey
      end

      it "deducts fare when touched out" do
        expect {oystercard.touch_out(station_out)}.to change(oystercard, :balance).by(-Oystercard::MINIMUM_FARE)
      end

    end


    context "#touch_out will cause the entry station to be forgotten" do

      it "Returns nil for station_in when touched out" do
        oystercard.touch_out(station_out)
        expect(oystercard.station_in).to be_nil
      end

    end

  end

  describe 'saving journey history' do
    let(:journey) { {entry: station_in, exit: station_out}}
    it 'saves one journey after touching in and out' do
      oystercard.top_up 10
      oystercard.touch_in(station_in)
      oystercard.touch_out(station_out)
      expect(oystercard.journey_hist).to include journey
    end
  end


end
