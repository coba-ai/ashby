# frozen_string_literal: true

require 'ashby/version'

module Ashby
  autoload :Base,        'ashby/base'
  autoload :Candidate,   'ashby/candidate'
  autoload :Interview,   'ashby/interview'
  autoload :Job,         'ashby/job'
  autoload :Application, 'ashby/application'

  @@api_key = nil

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.configure
    yield self
  end
end

require 'httparty'
require 'base64'
