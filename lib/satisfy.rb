require 'satisfy/version'

require 'satisfy/global'
require 'satisfy/runner'
require 'satisfy/define'
require 'satisfy/builder'
require 'satisfy/matcher'
require 'satisfy/placeholder'
require 'satisfy/errors'

module Satisfy
  module Steps
  end

  class << self
    attr_accessor :type
  end
end

Satisfy.type = :feature

Module.send(:include, Satisfy::Define)

extend Satisfy::Global
