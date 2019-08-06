RSpec.describe Ducksky do
  it "has a version number" do
    expect(Ducksky::VERSION).not_to be nil
  end
end

RSpec.describe Ducksky::Client do
  describe "#time_machine_request" do
    let(:api_key) { '1234qwer' }
    subject { described_class.new(api_key: api_key) }

    before do
      VCR.insert_cassette("time_machine_request/success")
    end

    after { VCR.eject_cassette }

    context 'without required params' do
      it 'raises error'
    end
    
    context 'with required params' do
      it 'sends a GET request to the darksky api' do
        expect(described_class)
          .to receive(:get)
          .with("/forecast/#{api_key}/5.498384,118.280899,2020-04-07T00:00:00+00:00")
          .and_call_original

        subject.time_machine_request(
          lat: 5.498384,
          lon: 118.280899,
          time: DateTime.new(2020, 04, 07)
        )
      end

      it 'converts response to a Ducksky::Response class' do
        response = subject.time_machine_request(
          lat: 5.498384,
          lon: 118.280899,
          time: DateTime.new(2020, 04, 07)
        )
        expect(response).to be_instance_of(Ducksky::Response)
        expect(response.latitude).to eq(5.498384)
      end

      it 'converts weather information to DataPoint instances' do
        response = subject.time_machine_request(
          lat: 5.498384,
          lon: 118.280899,
          time: DateTime.new(2020, 04, 07)
        )
        expect(response.currently).to be_instance_of(Ducksky::DataPoint)
        expect(response.currently.summary).to eq('Humid and Mostly Cloudy')
      end
    end
  end
end
