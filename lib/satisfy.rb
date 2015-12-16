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
end

Module.send(:include, Satisfy::Define)

extend Satisfy::Global
