require 'satisfy'
require 'pp'
require 'rspec'

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
          instance_eval <<-CONTEXT, test_spec, feature.line
            describe_feature = ::RSpec.describe(feature.name, feature.metadata_hash)
            execute_feature(describe_feature, feature, test_spec)
          CONTEXT
        end
      end

      private

      def execute_feature(describe_feature, feature, test_spec)
        describe_feature.before do
          feature.backgrounds.map(&:steps).flatten.each do |step|
            run(test_spec, step)
          end
        end

        feature.scenarios.each do |scenario|
          (puts 'SCENARIO:'; pp scenario) if ENV['SATISFY_TRACE']
          instance_eval <<-CONTEXT, test_spec, scenario.line
            describe_feature.describe(scenario.name, scenario.metadata_hash) do
              it(scenario.steps.map(&:to_s).join(' -> ')) do
                scenario.steps.each do |step|
                  run(test_spec, step)
                end
              end
            end
          CONTEXT
        end
      end
    end

    module SpecLoader
      def load(*files, &block)
        puts "Loading: #{files}" if ENV['SATISFY_TRACE']
        if files.first.end_with?('.feature', '.spec', '.story')
          load_helper 'satisfy_helper'
          load_helper 'spec_helper'

          Satisfy::RSpec.build_and_run(files.first)
        else
          super
        end
      end

      private

      def load_helper(file)
        require file
      rescue LoadError => e
        # This makes sure that errors raised in the spec_helper file
        # are not hidden by rescuing a load error.
        raise unless e.message.include?(file)
      end
    end

    module SpecRunner
      include Satisfy::StepRunner

      # @param test_spec [String] full path for test spec
      # @param step [Struct Satisfy::Builder::Step] the step to execute
      def run(test_spec, step)
        instance_eval <<-CONTEXT, test_spec, step.line
          step(step)
        CONTEXT
      rescue Satisfy::Pending => e
        example = ::RSpec.current_example
        example.metadata[:line_number] = step.line
        example.metadata[:location] = "#{example.metadata[:file_path]}:#{step.line}"

        if ::RSpec.configuration.raise_error_for_unimplemented_steps
          e.backtrace.push "#{test_spec}:#{step.line}:in `#{step.description}'"
          raise
        end

        skip("No matcher for step: '#{e}'")
      rescue StandardError, ::RSpec::Expectations::ExpectationNotMetError => e
        e.backtrace.push "#{test_spec}:#{step.line}:in `#{step.description}'"
        raise e
      end
    end
  end
end

::RSpec::Core::Configuration.send(:include, Satisfy::RSpec::SpecLoader)

::RSpec.configure do |config|
  config.pattern << ',**/*.feature,**/*.spec,**/*.story'
  config.include Satisfy::RSpec::SpecRunner, satisfy: true
  config.include Satisfy::Steps, satisfy: true
  config.add_setting :raise_error_for_unimplemented_steps, default: false
end
