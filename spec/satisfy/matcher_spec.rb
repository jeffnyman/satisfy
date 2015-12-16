RSpec.describe Satisfy::Matcher do
  describe 'matching' do
    it 'matches a simple step' do
      step = Satisfy::Matcher.new('all your base are belong to us') {}
      expect(step).to match('all your base are belong to us')
      expect(step).not_to match('all their base are belong to us')
      expect(step).not_to match('all their base are belong to me')
    end

    it 'matches placeholders within a step' do
      allow(Satisfy::Placeholder).to receive(:resolve).with(:count).and_return(/\d+/)
      step = Satisfy::Matcher.new('there are :count tests') {}
      expect(step).to match('there are 10 tests')
      expect(step).to match('there are 10000 tests')
      expect(step).not_to match('there are no tests')
    end

    it 'extracts arguments from matched steps' do
      step = Satisfy::Matcher.new("a :age year old tester called :name") {}
      match = step.match('a 43 year old tester called Jeff')
      expect(match.params).to eq(['43', 'Jeff'])
    end

    it 'can reuse the same placeholder multiple times' do
      step = Satisfy::Matcher.new('the testers :name and :name') {}
      match = step.match('the testers Jeff and Kasira')
      expect(match.params).to eq(['Jeff', 'Kasira'])
    end

    it 'can reuse the same custom placeholder multiple times' do
      allow(Satisfy::Placeholder).to receive(:resolve).with(:count).and_return(/\d+/)
      allow(Satisfy::Placeholder).to receive(:apply).with(:count, '3').and_return(3)
      allow(Satisfy::Placeholder).to receive(:apply).with(:count, '2').and_return(2)
      step = Satisfy::Matcher.new(":count testers and :count developers") {}
      match = step.match('3 testers and 2 developers')
      expect(match.params).to eq([3, 2])
    end

    it 'matches quoted placeholders' do
      step = Satisfy::Matcher.new('there is a tester named :name') {}
      expect(step).to match("there is a tester named 'Jeff'")
      expect(step).to match('there is a tester named "Jeff"')
    end

    it 'matches alternative words' do
      step = Satisfy::Matcher.new('there is/are testers') {}
      expect(step).to match('there are testers')
      expect(step).to match('there is testers')
      expect(step).not_to match('there be testers')
    end

    it 'matches several alternative words' do
      step = Satisfy::Matcher.new('testers are cool/nice/scary') {}
      expect(step).to match('testers are cool')
      expect(step).to match('testers are nice')
      expect(step).to match('testers are scary')
      expect(step).not_to match('testers are strange')
    end

    it 'matches optional parts of words' do
      step = Satisfy::Matcher.new('there is/are tester(s)') {}
      expect(step).to match('there is tester')
      expect(step).to match('there are testers')
    end

    it 'matches optional words' do
      step = Satisfy::Matcher.new('there is a (scary) tester') {}
      expect(step).to match('there is a tester')
      expect(step).to match('there is a scary tester')
      expect(step).not_to match('there is a terrifying tester')

      step = Satisfy::Matcher.new('there is a tester (that is scary)') {}
      expect(step).to match('there is a tester that is scary')
      expect(step).to match('there is a tester')

      step = Satisfy::Matcher.new('(there is) a tester') {}
      expect(step).to match('there is a tester')
      expect(step).to match('a tester')
    end
  end
end
