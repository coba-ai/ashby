module Ashby
  class Job < Ashby::Base
    attr_reader :title, :location_id, :department_id

    def initialize(attributes)
      super(attributes)
      @title = attributes['title']
      @location_id = attributes['locationId']
      @department_id = attributes['departmentId']
    end
  end
end
