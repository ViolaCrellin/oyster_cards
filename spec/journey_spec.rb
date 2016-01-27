require 'journey'

describe Journey do

  it {is_expected.to respond_to(:in_journey?)}

  it 'has an empty list of journeys by default' do
    expect(oystercard.journey_hist).to eq []
  end

  it 'has an empty hash to save current journey' do
    expect(oystercard.this_journey).to eq ({})
  end

end
