module Ashby
  class Interview < Ashby::Base
    def initialize(attributes)
      super(attributes)
      @title = attributes['title']
      @type = attributes['type']
      @interview_plan_id = attributes['interviewPlanId']
      @order_interview_plan = attributes['orderInterviewPlan']
    end
  end
end
