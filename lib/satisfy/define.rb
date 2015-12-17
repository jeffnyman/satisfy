module Satisfy
  module Define
    def step(method_name = nil, name, &block)
      raise ArgumentError, "Do not specify method name and a block for a step." if method_name && block
      step = Satisfy::Matcher.new(name, method_name, caller.first, &block)
      send(:define_method, "matcher: #{name}") { |step_name| step.match(step_name) }
      send(:define_method, name, &block) if block
    end
  end
end
