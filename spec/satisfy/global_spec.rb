RSpec.describe Satisfy::Global do
  let(:context) { double.tap { |s| s.extend(Satisfy::Global) }}
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
end
