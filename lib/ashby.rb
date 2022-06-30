# frozen_string_literal: true

require_relative 'ashby/version'

module Ashby
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
require_relative 'ashby/base'
require_relative 'ashby/candidate'
require_relative 'ashby/interview'
require_relative 'ashby/job'
require_relative 'ashby/application'
