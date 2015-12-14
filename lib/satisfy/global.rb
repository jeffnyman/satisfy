module Satisfy
  module Global
    def step(name, &block)
      Satisfy::Steps.step(name, &block)
    end
  end
end
