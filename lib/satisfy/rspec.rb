require 'pp'
require 'rspec'
require 'satisfy/errors'
require 'satisfy/builder'
require 'satisfy/runner'

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
          # (puts 'SPEC:'; pp feature) if ENV['SATISFY_TRACE']
          ::RSpec.describe feature.name do
            feature.scenarios.each do |scenario|
              # (puts 'SCENARIO:'; pp scenario) if ENV['SATISFY_TRACE']
              describe scenario.name do
                scenario.steps.each do |step|
                  # (puts 'STEP:'; pp step) if ENV['SATISFY_TRACE']
                  it step do
                    run(test_spec, step)
                  end
                end
              end
            end
          end
        end
      end
    end

    module SpecLoader
      def load(*files, &block)
        puts "Loading: #{files}" if ENV['SATISFY_TRACE']
        if files.first.end_with?('.feature', '.spec', '.story')
          Satisfy::RSpec.build_and_run(files.first)
        else
          super
        end
      end
    end

    module SpecRunner
      include Satisfy::StepRunner

      # @param test_spec [String] full path for test spec
      # @param step [Struct Satisfy::Builder::Step] the step to execute
      def run(_test_spec, step)
        step(step)
      rescue Satisfy::Pending => e
        skip("No matcher for step: '#{e}'")
      end
    end
  end
end

::RSpec::Core::Configuration.send(:include, Satisfy::RSpec::SpecLoader)

::RSpec.configure do |config|
  config.pattern << ',**/*.feature,**/*.spec,**/*.story'
  config.include Satisfy::RSpec::SpecRunner
end
