module Satisfy
  module StepRunner
    # @param step [Struct Satisfy::Builder::Step] the step to execute
    # @see Satisfy::RSpec::SpecRunner.run
    def step(step, *step_args)
      if step.respond_to?(:step_args)
        description = step.name
        step_args.concat(step.step_args)
      else
        description = step
      end

      step_matches = methods.map do |method|
        next unless method.to_s.start_with?('matcher: ')
        send(method.to_s, description)
      end.compact

      raise(Satisfy::Pending, description) if step_matches.length == 0

      if step_matches.length > 1
        message = ['Ambiguous steps'].concat(step_matches.map(&:trace)).join("\r\n")
        raise Satisfy::Ambiguous, message
      end

      send(step_matches.first.method_name, *(step_matches.first.params + step_args))
    end
  end
end
