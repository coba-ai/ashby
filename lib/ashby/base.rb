module Ashby
  class Base
    include HTTParty

    base_uri 'https://api.ashbyhq.com'
    basic_auth Ashby.api_key, nil

    attr_reader :id, :custom_fields

    def initialize(attributes)
      @id = attributes['id']
      @custom_fields = attributes['customFields']
    end

    def self.headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end
  end
end
