# frozen_string_literal: true

RSpec.describe Ashby do
  it { is_expected.to respond_to(:api_key) }

  it "returns the set value for the api key" do
    Ashby.configure do |config|
      config.api_key = "a-sample-api-key"
    end

    expect(Ashby.api_key).to eql "a-sample-api-key"
  end

  it "has a version number" do
    expect(Ashby::VERSION).not_to be nil
  end
end
