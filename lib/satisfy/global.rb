module Satisfy
  module Global
    def step(name, &block)
      Satisfy::Steps.step(name, &block)
    end

    def placeholder(*name, &block)
      name.each do |n|
        Satisfy::Placeholder.add(n, &block)
      end
    end
  end
end
