module Satisfy
  module Define
    def step(method_name = nil, name, &block)
      step = Satisfy::Matcher.new(name, method_name, caller.first, &block)
      send(:define_method, "matcher: #{name}") { |step_name| step.match(step_name) }
      send(:define_method, name, &block) if block
    end
  end
end
