module Ashby
  class Candidate < Ashby::Base
    attr_reader :name,
                :primary_email,
                :phone_numbers,
                :social_links,
                :tags,
                :application_ids,
                :file_handles,
                :custom_fields,
                :position,
                :company

    def initialize(attributes)
      super(attributes)
      @name = attributes['name']
      @primary_email = attributes['primaryEmailAddress']['value'] if attributes['primaryEmailAddress']
      @phone_numbers = attributes['phoneNumbers']
      @social_links = attributes['socialLinks']
      @tags = attributes['tags']
      @application_ids = attributes['applicationIds']
      @file_handles = attributes['fileHandles']
      @position = attributes['position']
      @company = attributes['company']
    end

    def self.search(body)
      response = post('/candidate.search', body: body.to_json, headers: headers)

      raise response.parse_body['error'] unless response.ok?

      response['results'].map do |attributes|
        new(attributes)
      end
    end

    def self.find(id)
      response = post('/candidate.info', body: { id: id }.to_json, headers: headers)

      raise response.parse_body['error'] unless response.ok?

      new(response['results'])
    end

    def self.create(attributes)
      response = post('/candidate.create', body: attributes.to_json, headers: headers)

      raise response.parse_body['error'] unless response.ok?

      new(response['results'])
    end
  end
end
