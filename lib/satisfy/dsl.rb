module Satisfy
  module DSL
    def step(name, &block)
      Satisfy::Steps.step(name, &block)
    end

    def placeholder(*name, &block)
      name.each do |n|
        Satisfy::Placeholder.add(n, &block)
      end
    end

    def steps_for(tag, &block)
      Module.new do
        singleton_class.send(:define_method, :tag) { tag }
        module_eval(&block)
        ::RSpec.configure { |c| c.include self, tag => true }
      end
    end
  end
end
