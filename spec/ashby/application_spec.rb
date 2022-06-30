RSpec.describe Ashby::Application do
  let(:attributes) do
    {
      'id' => 'f6c0aebb-db86-4fcc-8815-18a701744522',
      'createdAt' => '2022-05-20T15=>18=>48.665Z',
      'updatedAt' => '2022-06-23T00=>32=>30.136Z',
      'candidate' => {
        'id' => '152fc51a-69f1-4815-b642-2f314ed22975',
        'name' => 'John Wick',
        'primaryEmailAddress' => {
          'value' => 'john@wick.com',
          'type' => 'Personal',
          'isPrimary' => true
        }
      },
      'status' => 'Active',
      'customFields' => [],
      'currentInterviewStage' => {
        'id' => '8c2955af-1318-4800-9343-8828bdedd470',
        'title' => 'First Interview',
        'type' => 'Active',
        'interviewPlanId' => '651e04ab-3651-459b-9a75-77a792bf7aec',
        'orderInInterviewPlan' => 5
      },
      'source' => {
        'id' => 'e2ee478c-71db-4dd5-97da-faf480071ad3',
        'title' => 'Linkedin',
        'isArchived' => false
      },
      'creditedToUser' => nil,
      'archiveReason' => nil,
      'job' => {
        'id' => '968209bc-521d-4094-9bc1-fd5e56e70b87',
        'title' => '[Acme Inc] Front-end Engineer',
        'locationId' => 'f99fe689-2d70-4ddd-b7f6-9e65dc87b8a6',
        'departmentId' => '4a6cd1dd-5ed2-4a6c-bb38-ee406675184f'
      },
      'applicationHistory' => [
        {
          'stageId' => 'd7783394-a800-4b9b-882a-fcaffe955b02',
          'title' => 'Accepted for interview',
          'enteredStageAt' => '2022-05-20T15=>18=>48.712Z',
          'leftStageAt' => '2022-05-25T14=>18=>28.238Z'
        },
        {
          'stageId' => '8c2955af-1318-4800-9343-8828bdedd470',
          'title' => 'First Interview',
          'enteredStageAt' => '2022-05-25T14=>18=>28.239Z',
          'leftStageAt' => nil
        }
      ]
    }
  end

  subject { Ashby::Application.new(attributes) }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:custom_fields) }
  it { is_expected.to respond_to(:created_at) }
  it { is_expected.to respond_to(:updated_at) }
  it { is_expected.to respond_to(:candidate) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:current_interview_stage) }
  it { is_expected.to respond_to(:source) }
  it { is_expected.to respond_to(:credited_to_user) }
  it { is_expected.to respond_to(:archive_reason) }
  it { is_expected.to respond_to(:job) }
  it { is_expected.to respond_to(:history) }

  describe '#find' do
    let(:response) do
      {
        success: true,
        results: {
          id: '37957ac3-2369-4018-9c08-61f330ee84fe',
          createdAt: '2022-05-20T16:48:17.121Z',
          updatedAt: '2022-06-23T00:32:30.911Z',
          candidate: {
            id: '561cdd98-c23b-473a-bcdb-1a44c0b09d87',
            name: 'John Wick',
            primaryEmailAddress: {
              value: 'john@wick.com',
              type: 'Personal',
              isPrimary: true
            }
          },
          status: 'Active',
          customFields: [],
          currentInterviewStage: {
            id: '77f76946-e85e-4cd5-aa45-283d4e3e95b7',
            title: 'Accepted for interview',
            type: 'Active',
            interviewPlanId: '50d89a19-241a-437a-bd97-b67d177e6dbe',
            orderInInterviewPlan: 4
          },
          source: nil,
          creditedToUser: nil,
          archiveReason: nil,
          job: {
            id: 'cb625a32-3fe8-474d-91be-53eb2e0f4d93',
            title: '[Acme] Front-end Engineer',
            locationId: 'f99fe689-2d70-4ddd-b7f6-9e65dc87b8a6',
            departmentId: 'ca78ff6d-a808-4ea8-9c74-41a54119a9ae'
          },
          applicationHistory: [
            {
              stageId: '77f76946-e85e-4cd5-aa45-283d4e3e95b7',
              title: 'Accepted for interview',
              enteredStageAt: '2022-05-20T16:48:17.157Z',
              leftStageAt: nil
            }
          ]
        }
      }
    end

    before do
      stub_request(:post, 'https://api.ashbyhq.com/application.info')
        .with(
          body: '{"applicationId":1}',
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'Basic Og==',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        ).to_return(status: 200, body: response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an application' do
      application = described_class.find(1)

      expect(application.id).to eq('37957ac3-2369-4018-9c08-61f330ee84fe')
      expect(application.source).to be_a(Ashby::Application::Source)
      expect(application.history).to be_a(Array)
      expect(application.history.first).to be_a(Ashby::Application::History)
      expect(application.job).to be_a(Ashby::Job)
      expect(application.status).to eq('Active')
    end
  end
end
