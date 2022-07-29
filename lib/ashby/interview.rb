module Ashby
  class Interview < Ashby::Base
    attr_reader :title

    def initialize(attributes)
      super(attributes)
      @title = attributes['title']
      @type = attributes['type']
      @interview_plan_id = attributes['interviewPlanId']
      @order_interview_plan = attributes['orderInterviewPlan']
    end
  end
end
