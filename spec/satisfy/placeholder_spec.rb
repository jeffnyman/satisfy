RSpec.describe Satisfy::Placeholder do
  def anchor(exp)
    Regexp.new("^#{exp}$")
  end

  describe 'resolving' do
    it "fall through to using the standard placeholder regexp" do
      resolved = Satisfy::Placeholder.resolve(:does_not_exist)
      expect('foo').to match (anchor(resolved))
      expect('"this is a test"').to match (anchor(resolved))
      expect("foo bar").not_to match (anchor(resolved))
    end
  end

  describe 'regular expression handling' do
    it 'matches a given fragment' do
      placeholder = Satisfy::Placeholder.new(:test) { match(/testing/) }
      expect('testing').to match(placeholder.regexp)
    end

    it 'matches multiple fragments' do
      placeholder = Satisfy::Placeholder.new(:test) { match(/testing/); match(/\d/) }
      expect('testing').to match(placeholder.regexp)
      expect('5').to match(placeholder.regexp)
    end

    it 'does not match incorrect fragments' do
      placeholder = Satisfy::Placeholder.new(:test) { match(/testing/) }
      expect('quality').not_to match(placeholder.regexp)
    end

    it 'does not match multiple incorrect fragments' do
      placeholder = Satisfy::Placeholder.new(:test) { match(/testing/); match(/\d/) }
      expect('quality').not_to match(placeholder.regexp)
    end
  end
end
