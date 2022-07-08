module Ashby
  class Application < Ashby::Base
    attr_reader :created_at,
                :updated_at,
                :candidate,
                :status,
                :custom_fields,
                :current_interview_stage,
                :source,
                :credited_to_user,
                :archive_reason,
                :job,
                :history

    def initialize(attributes)
      super(attributes)
      @created_at = Time.parse(attributes['createdAt'])
      @updated_at = Time.parse(attributes['updatedAt'])
      @candidate = Ashby::Candidate.new(attributes['candidate'])
      @status = attributes['status']
      @current_interview_stage = Ashby::Interview.new(attributes['currentInterviewStage'])
      @source = Ashby::Application::Source.new(attributes['source'] || {})
      @credited_to_user = attributes['creditedToUser']
      @archive_reason = attributes['archiveReason']
      @job = Ashby::Job.new(attributes['job'])
      @history = attributes['applicationHistory'].map { |h| Ashby::Application::History.new(h) }
    end

    def self.find(id)
      response = post('/application.info', body: { applicationId: id }.to_json, headers: headers)

      raise response.parsed_response unless response.ok?

      new(response['results'])
    end

    class Source
      attr_reader :id, :title, :is_archived

      def initialize(attributes = nil)
        return if attributes.empty?

        @id = attributes['id']
        @title = attributes['title']
        @is_archived = attributes['isArchived']
      end
    end

    class History
      attr_reader :stage_id, :title, :entered_stage_at, :left_stage_at

      def initialize(attributes)
        @stage_id = attributes['stageId']
        @title = attributes['title']
        @entered_stage_at = Time.parse(attributes['enteredStageAt'])
        @left_stage_at = Time.parse(attributes['leftStageAt']) if attributes['leftStageAt']
      end
    end
  end
end
