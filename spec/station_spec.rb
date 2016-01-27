require 'station'

describe Station do
  let(:name) { double :name}
  let(:zone) { double :zone}
  subject(:station) {described_class.new("bank", 5)}

  describe "#initialize" do

    it {is_expected.to respond_to(:name)}

    it {is_expected.to respond_to(:zone)}

  end

  it "knows its name" do
    expect(station.name).to eq "bank"
  end

  it "knows its zone" do
    expect(station.zone).to eq 5
  end


end
