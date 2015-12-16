RSpec.describe Satisfy::StepRunner do
  let(:mod) { Module.new }
  let(:obj) { Object.new.tap { |o| o.extend Satisfy::StepRunner; o.extend mod } }

  it 'will indicate a step is pending if a matcher is not found' do
    test_step = Satisfy::Builder::Step.new('* ', 'truth is truth', 27, [])
    expect {obj.step(test_step)}.to raise_error(Satisfy::Pending)
  end

  it 'defines a step method and makes it callable' do
    mod.step('a test step') { 'testing' }
    expect(obj.step('a test step')).to eq('testing')
  end

  it 'allows placeholders to be filled and passed as arguments' do
    mod.step('a :test step') { |test| test.upcase }
    expect(obj.step('a simple step')).to eq('SIMPLE')
  end

  it 'allows step to be called as a method via `send`' do
    mod.step('a :test step') { |test| test.upcase }
    expect(obj.send('a :test step', 'testing')).to eq('TESTING')
  end

  it 'can use an existing method as a step' do
    mod.module_eval do
      def a_test_step(test)
        test.upcase
      end
    end
    mod.step(:a_test_step, 'a :test step')
    expect(obj.step('a testing step')).to eq('TESTING')
  end

  it 'sends in step arguments from a builder step' do
    mod.step('a :test step') { |test, arg| test.upcase + arg }
    expect(obj.step('a testing step', 'smart')).to eq('TESTINGsmart')
  end

  it 'can be executed with a builder step' do
    builder_step = double(name: 'a testing step', step_args: [])
    mod.step('a :test step') { |test| test.upcase }
    expect(obj.step(builder_step)).to eq('TESTING')
  end

  it 'sends in extra arg from a builder step' do
    builder_step = double(name: 'a testing step', step_args: ['smart'])
    mod.step('a :test step') { |test, arg| test.upcase + arg }
    expect(obj.step(builder_step)).to eq('TESTINGsmart')
  end

  it 'defines ambiguous steps' do
    mod.step('an ambiguous step') {}
    mod.step('an :ambiguous step') {}
    expect {
      obj.step('an ambiguous step')
    }.to raise_error(Satisfy::Ambiguous)
  end

  it 'shows useful information on the ambiguous steps' do
    mod.step('an ambiguous step') {}
    mod.step('an :ambiguous step') {}
    expect {
      obj.step('an ambiguous step')
    }.to raise_error(Satisfy::Ambiguous, %r{(ambiguous).*(runner_spec.rb)})
  end
end
