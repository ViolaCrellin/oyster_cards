require 'oystercard'

describe Oystercard do

  #DOUBLES
  let(:dummy_journey_klass) {double :dummy_journey_klass}
  let(:dummy_journey) {double :dummy_journey}
  subject(:oystercard) {described_class.new dummy_journey_klass}
  let(:station_in) { double :station}
  let(:station_out) { double :station}



  #MAGIC NUMBERS
  let(:topup_amount) {10}
  let(:random_topup_amount) {rand(1..20)}
  let(:too_large_topup) {91}
  let(:standard_fare) {1}
  let(:penalty_fare)  {6}


before do
  allow(dummy_journey_klass).to receive(:new).and_return dummy_journey
  allow(dummy_journey).to receive(:start_journey).with(station_in)
  allow(dummy_journey).to receive(:end_journey).with(station_out)
  allow(dummy_journey).to receive(:this_journey)
  allow(dummy_journey).to receive(:completed?)
  allow(dummy_journey).to receive(:fare)
end


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
        expect {poor_oystercard.touch_in(station_in)}.to raise_error "Please top up your Oystercard"
      end

    end

  end




  describe "#touch out" do

    before do
      oystercard.top_up topup_amount
    end

      it "returns nil for entry_station when touched out" do
        allow(dummy_journey).to receive(:fare).and_return standard_fare
        oystercard.touch_in(station_in)
        oystercard.touch_out(station_out)
        expect(oystercard.entry_station).to be nil
      end

    context "Deducting fares on #touch out" do


      it "deducts standard fare when touched out and touched in" do
        allow(dummy_journey).to receive(:completed?).and_return true
        allow(dummy_journey).to receive(:fare).and_return standard_fare
        oystercard.touch_in(station_in)
        oystercard.touch_out(station_out)
        expect(oystercard.balance).to eq 9
      end

      it "deducts penalty when you don't touch in but have touched out" do
        allow(dummy_journey).to receive(:completed?).and_return false
        allow(dummy_journey).to receive(:fare).and_return penalty_fare
        expect {oystercard.touch_out(station_out)}.to change(oystercard, :balance).by(-penalty_fare)
      end

    end




    context "recording #journey_hist" do


          let(:completed_journey) { {entry: station_in, exit: station_out}}
          let(:in_only_journey) {{entry: station_in}}
          let(:out_only_journey) {{exit: station_out}}


          before do
            oystercard.top_up topup_amount
          end

          it 'saves one journey after touching in and out to journey_hist' do
            allow(dummy_journey).to receive(:completed?).and_return true
            allow(dummy_journey).to receive(:fare).and_return standard_fare
            allow(dummy_journey).to receive(:this_journey).and_return completed_journey
            oystercard.touch_in(station_in)
            oystercard.touch_out(station_out)
            expect(oystercard.journey_hist).to include completed_journey
          end

          before do
            allow(dummy_journey).to receive(:completed?).and_return false
            allow(dummy_journey).to receive(:fare).and_return penalty_fare
          end

          it 'saves an incomplete journey when you touch in twice consecutively' do
            allow(dummy_journey).to receive(:this_journey).and_return in_only_journey
            oystercard.touch_in(station_in)
            oystercard.touch_in(station_in)
            expect(oystercard.journey_hist).to include in_only_journey
          end

          it 'saves an incomplete journey when you touch out twice consecutively' do
            allow(dummy_journey).to receive(:this_journey).and_return out_only_journey
            oystercard.touch_out(station_out)
            oystercard.touch_out(station_out)
            expect(oystercard.journey_hist).to include out_only_journey
          end


    end
  end
end
