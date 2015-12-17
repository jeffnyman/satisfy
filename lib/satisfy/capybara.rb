require 'capybara/rspec'

RSpec.configure do |config|
  config.before do
    current_example = RSpec.current_example

    if self.class.include?(Capybara::DSL) && current_example.metadata[:turnip]
      Capybara.current_driver = Capybara.javascript_driver if current_example.metadata.key?(:javascript)
      current_example.metadata.each do |tag, _value|
        Capybara.current_driver = tag if Capybara.drivers.key?(tag)
      end
    end
  end
end
