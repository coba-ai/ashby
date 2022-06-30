# frozen_string_literal: true

require "ashby/version"

module Ashby
  @@token = nil

  def self.token=(token)
    @@token = token
  end

  def self.token
    @@token
  end

  def self.configure
    yield self
  end
end
