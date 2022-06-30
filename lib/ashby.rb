# frozen_string_literal: true

require "ashby/version"

module Ashby
  @@api_key = nil

  def self.api_key=(token)
    @@api_key = token
  end

  def self.api_key
    @@api_key
  end

  def self.configure
    yield self
  end
end
