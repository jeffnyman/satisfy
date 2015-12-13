require 'pp'
require 'rspec'
require 'satisfy/builder'

module Satisfy
  module RSpec
    class << self
      def build_and_run(test_spec)
        # The call to build() will return an instance that contains a
        # specs instance variable. That, in turn, will contain a
        # representation of the test spec that was processed. That
        # will be a Feature implementation, since a Feature is how
        # Gherkin represents a test spec.
        Satisfy::Builder.build(test_spec).specs.each do |feature|
          (puts 'SPEC:'; pp feature) if ENV['SATISFY_TRACE']
        end
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
