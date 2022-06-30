RSpec.describe Ashby::Application do
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
