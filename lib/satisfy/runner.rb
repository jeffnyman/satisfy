module Satisfy
  module StepRunner
    # @param step [Struct Satisfy::Builder::Step] the step to execute
    # @see Satisfy::RSpec::SpecRunner.run
    def step(step)
      step_matches = methods.map do |method|
        next unless method.to_s.start_with?('matcher: ')
      end.compact

      raise(Satisfy::Pending, step.name) if step_matches.length == 0
    end
  end
end
