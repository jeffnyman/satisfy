RSpec.describe Satisfy::DSL do
  let(:context) { double.tap { |s| s.extend(Satisfy::DSL) }}
  let(:an_object) { Object.new.tap { |o| o.extend(Satisfy::StepRunner) }}

  describe 'step' do
    it 'adds steps to Satisfy::Steps' do
      context.step('this is a test') { 'foo' }
      context.step('this is another test') { 'bar' }
      an_object.extend Satisfy::Steps
      expect(an_object.step('this is a test')).to eq('foo')
    end
  end

  describe 'placeholder' do
    before { Satisfy::Placeholder.send(:placeholders).clear }

    it 'registers the placeholder globally' do
      context.placeholder('example') { true }
      expect(Satisfy::Placeholder.send(:placeholders)).to have_key('example')
    end

    it 'registers multiple placeholders globally' do
      context.placeholder('example_1', 'example_2') { true }
      expect(Satisfy::Placeholder.send(:placeholders)).to have_key('example_1')
      expect(Satisfy::Placeholder.send(:placeholders)).to have_key('example_2')
    end
  end

  describe 'steps_for' do
    before do
      allow(::RSpec).to receive(:configure)
    end

    it 'creates a new module and adds steps to it' do
      mod = context.steps_for(:testing) do
        step('testing') { 'testing' }
      end
      an_object.extend mod
      expect(an_object.step('testing')).to eq 'testing'
    end

    it 'remembers the name of the module' do
      mod = context.steps_for(:testing) {}
      expect(mod.tag).to eq :testing
    end

    it 'tells rspec to include the module' do
      config = double
      expect(RSpec).to receive(:configure).and_yield(config)
      expect(config).to receive(:include)
      context.steps_for(:foo) {}
    end
  end
end
