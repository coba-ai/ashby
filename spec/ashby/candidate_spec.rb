RSpec.describe Ashby::Candidate do
  let(:attributes) do
    {
      'id' => '152fc51a-69f1-4815-b642-2f314ed22975',
      'name' => 'John Wick',
      'primaryEmailAddress' => {
        'value' => 'john@wick.com',
        'type' => 'Personal',
        'isPrimary' => true
      },
      'emailAddresses' => [
        {
          'value' => 'john@wick.com',
          'type' => 'Personal',
          'isPrimary' => true
        }
      ],
      'phoneNumbers' => [
        {
          'value' => '1234567890',
          'type' => 'Personal',
          'isPrimary' => true
        }
      ],
      'socialLinks' => [
        {
          'type' => 'LinkedIn',
          'url' => 'https://www.linkedin.com/in/john-wick/'
        }
      ],
      'tags' => [],
      'position' => 'Software Engineer',
      'company' => 'Acme Inc.',
      'applicationIds' => %w[
        a970e8c2-6c64-4e40-838c-2b676be50e7a
      ],
      'fileHandles' => [],
      'customFields' => []
    }
  end

  subject { Ashby::Candidate.new(attributes) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:primary_email) }
  it { is_expected.to respond_to(:phone_numbers) }
  it { is_expected.to respond_to(:social_links) }
  it { is_expected.to respond_to(:tags) }
  it { is_expected.to respond_to(:application_ids) }
  it { is_expected.to respond_to(:file_handles) }
  it { is_expected.to respond_to(:position) }
  it { is_expected.to respond_to(:company) }
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:custom_fields) }

  before do
    Ashby.configure do |config|
      config.api_key = 'some-api-key'
    end
  end

  let(:response) do
    {
      "success": true,
      "results": {
        "id": '152fc51a-69f1-4815-b642-2f314ed22975',
        "name": 'John Wick',
        "primaryEmailAddress": {
          "value": 'john@wick.com',
          "type": 'Personal',
          "isPrimary": true
        },
        "emailAddresses": [
          {
            "value": 'john@wick.com',
            "type": 'Personal',
            "isPrimary": true
          }
        ],
        "phoneNumbers": [
          {
            "value": '1234567890',
            "type": 'Personal',
            "isPrimary": true
          }
        ],
        "socialLinks": [
          {
            "type": 'LinkedIn',
            "url": 'https://www.linkedin.com/in/john-wick/'
          }
        ],
        "tags": [],
        "position": 'Software Engineer',
        "company": 'Acme Inc.',
        "applicationIds": %w[
          a970e8c2-6c64-4e40-838c-2b676be50e7a
        ],
        "fileHandles": [],
        "customFields": []
      }
    }
  end

  describe '#find' do
    before do
      stub_request(:post, 'https://api.ashbyhq.com/candidate.info')
        .with(
          body: '{"id":"152fc51a-69f1-4815-b642-2f314ed22975"}',
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'Basic Og==',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an instance of candidate' do
      candidate = Ashby::Candidate.find('152fc51a-69f1-4815-b642-2f314ed22975')

      expect(candidate.id).to eq('152fc51a-69f1-4815-b642-2f314ed22975')
      expect(candidate.name).to eq('John Wick')
      expect(candidate.primary_email).to eq('john@wick.com')
      expect(candidate.position).to eq('Software Engineer')
      expect(candidate.company).to eq('Acme Inc.')
      expect(candidate.application_ids).to eq(['a970e8c2-6c64-4e40-838c-2b676be50e7a'])
    end
  end

  describe '#search' do
    let(:response) do
      {
        success: true,
        results: [
          {
            id: '561cdd98-c23b-473a-bcdb-1a44c0b09d87',
            name: 'John Wick',
            primaryEmailAddress: {
              value: 'john@wick.com',
              type: 'Personal',
              isPrimary: true
            },
            emailAddresses: [
              {
                value: 'john@wick.com',
                type: 'Personal',
                isPrimary: true
              }
            ],
            phoneNumbers: [],
            socialLinks: [
              {
                type: 'LinkedIn',
                url: 'https://www.linkedin.com/in/john-wick/'
              }
            ],
            tags: [],
            position: 'FullStack React & Rails developer',
            company: 'Acme Inc.',
            applicationIds: [
              '37957ac3-2369-4018-9c08-61f330ee84fe'
            ],
            fileHandles: [],
            customFields: []
          }
        ]
      }
    end

    before do
      stub_request(:post, 'https://api.ashbyhq.com/candidate.search')
        .with(
          body: '{"email":"john@wick.com"}',
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'Basic Og==',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an array of candidates matching the email' do
      candidates = Ashby::Candidate.search(email: 'john@wick.com')

      expect(candidates.count).to eq(1)
      expect(candidates.first).to be_a(Ashby::Candidate)
    end
  end
end
