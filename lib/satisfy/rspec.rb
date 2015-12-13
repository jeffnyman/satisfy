require 'pp'
require 'rspec'

module Satisfy
  module RSpec
    class << self
      def build_and_run(test_spec)
      end
    end

    module SpecLoader
      # @param files [Array] test specs to be executed
      def load(*files, &block)
        puts "Loading: #{files}" if ENV['SATISFY_TRACE']
        if files.first.end_with?('.feature', '.spec', '.story')
          Satisfy::RSpec.build_and_run(files.first)
        else
          super
        end
      end
    end
  end
end

::RSpec::Core::Configuration.send(:include, Satisfy::RSpec::SpecLoader)

::RSpec.configure do |config|
  config.pattern << ',**/*.feature,**/*.spec,**/*.story'
end
