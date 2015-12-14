module Satisfy
  module Define
    def step(name)
      step = Satisfy::Matcher.new(name)
      send(:define_method, "matcher: #{name}") { |step_name| true }
    end
  end
end
