require_relative "./../app/application_report"

RSpec.describe ApplicationReport do
  let(:service) { described_class.new("applications.json") }
  let(:expected_response) do
    {
      0 => 1,
      1 => 3,
      2 => 2,
      3 => 3,
      4 => 1,
      5 => 2,
      6 => 1,
      7 => 1,
      8 => 1,
      9 => 4,
      10 => 3,
      11 => 4,
      12 => 3,
      13 => 4,
      14 => 2,
      15 => 3,
      16 => 2,
      17 => 3,
      18 => 3,
      19 => 3,
      20 => 3,
      21 => 4,
      22 => 1,
      23 => 3
    }
  end

  # This is the default RSpec example without filters and using the
  # standard `application.json` attachment as the source of information.
  it "returns the averages by hour" do
    expect(service.retrieve_trend).to eq expected_response
  end

  context "with channel filter" do
    let(:expected_response_qr) do
      {
        0 => 0,
        1 => 1,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 1,
        6 => 0,
        7 => 0,
        9 => 1,
        10 => 1,
        11 => 2,
        12 => 1,
        13 => 2,
        14 => 1,
        15 => 1,
        16 => 0,
        17 => 1,
        18 => 2,
        19 => 1,
        20 => 1,
        21 => 2,
        23 => 1
      }
    end

    let(:expected_response_sales) do
      {
        0 => 1,
        1 => 1,
        2 => 1,
        3 => 1,
        5 => 1,
        6 => 0,
        8 => 1,
        9 => 1,
        10 => 2,
        11 => 2,
        12 => 2,
        13 => 0,
        14 => 1,
        15 => 1,
        16 => 1,
        17 => 1,
        18 => 1,
        19 => 1,
        20 => 2,
        21 => 1,
        23 => 1
      }
    end

    let(:expected_response_website) do
      {
        0 => 0,
        1 => 1,
        2 => 1,
        3 => 1,
        4 => 1,
        5 => 0,
        6 => 0,
        7 => 1,
        8 => 0,
        9 => 2,
        10 => 0,
        11 => 1,
        12 => 1,
        13 => 2,
        14 => 1,
        15 => 1,
        16 => 1,
        17 => 1,
        19 => 1,
        20 => 0,
        21 => 2,
        22 => 1,
        23 => 1
      }
    end

    it "returns the averages by hour for 'qr' channel" do
      expect(service.retrieve_trend("qr")).to eq expected_response_qr
    end

    it "returns the averages by hour for 'sales' channel" do
      expect(service.retrieve_trend("sales")).to eq expected_response_sales
    end

    it "returns the averages by hour for 'website' channel" do
      expect(service.retrieve_trend("website")).to eq expected_response_website
    end
  end

  context "with invalid channel filter" do
    it "returns an empty hash" do
      expect(service.retrieve_trend("invalid_channel")).to eq({})
    end
  end

  context "with nil channel parameter" do
    it "returns the averages by hour" do
      expect(service.retrieve_trend(nil)).to eq expected_response
    end
  end

  context "with empty applications.json" do
    let(:empty_service) { described_class.new("empty_applications.json") }

    it "returns an empty hash for all channels" do
      expect(empty_service.retrieve_trend).to eq({})
    end

    it "returns an empty hash for qr channels" do
      expect(empty_service.retrieve_trend("qr")).to eq({})
    end

    it "returns an empty hash for sales channels" do
      expect(empty_service.retrieve_trend("sales")).to eq({})
    end

    it "returns an empty hash for website channels" do
      expect(empty_service.retrieve_trend("website")).to eq({})
    end
  end
end
