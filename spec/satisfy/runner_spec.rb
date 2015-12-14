RSpec.describe Satisfy::StepRunner do
  let(:mod) { Module.new }
  let(:obj) { Object.new.tap { |o| o.extend Satisfy::StepRunner; o.extend mod } }

  it 'will indicate a step is pending if a matcher is not found' do
    test_step = Satisfy::Builder::Step.new('* ', 'truth is truth', 27, [])
    expect {obj.step(test_step)}.to raise_error(Satisfy::Pending)
  end
end
