RSpec.describe Satisfy::Table do
  let(:table) { described_class.new( repr ) }
  let(:repr) { [['answer', 'source'], ['42', 'hitchhiker']] }

  describe 'representation' do
    it 'returns the raw table' do
      expect(table.repr).to eq [['answer', 'source'], ['42', 'hitchhiker']]
    end

    it 'reflects changes in the table' do
      table.repr[1][0] = '37'
      expect(table.repr).to eq [['answer', 'source'], ['37', 'hitchhiker']]
    end
  end

  describe 'headers' do
    it 'returns the first row' do
      expect(table.headers).to eq ['answer', 'source']
    end
  end

  describe 'rows' do
    let(:repr) { [['answer', 'source'], ['thx1137', 'star wars'], ['42', 'hitchhiker']] }
    it 'returns the rows beyond the first' do
      expect(table.rows).to eq [['thx1137', 'star wars'], ['42', 'hitchhiker']]
    end
  end

  describe 'hashes' do
    let(:repr) { [['answer', 'source'], ['thx1137', 'star wars'], ['42', 'hitchhiker']] }
    it 'returns a list of hashes based on the headers' do
      expect(table.hashes).to eq [
        {'answer' => 'thx1137', 'source' => 'star wars'},
        {'answer' => '42', 'source' => 'hitchhiker'}
      ]
    end
  end

  describe 'transpose' do
    context "when table is two columns wide" do
      let(:repr) { [['Name', 'Jeff'], ['Age', '43'], ['Height', '6ft']] }
      it 'transposes the raw table' do
        expect(table.transpose.hashes).to eq [
          { 'Name' => 'Jeff', 'Age' => '43', 'Height' => '6ft' }
        ]
      end
    end
  end

  describe 'rows_hash' do
    let(:repr) { [['answer', 'source'], ['42', 'hitchhiker']] }
    it 'converts table to a hash with first column as keys, second column as values' do
      expect(table.rows_hash).to eq({'answer' => 'source', '42' => 'hitchhiker'})
    end

    context "when table is greater than 2 columns wide" do
      let(:repr) { [['a', 'b', 'c'], ['1', '2', '3']] }

      it 'raises an error' do
        expect { table.rows_hash }.to raise_error Satisfy::ColumnMismatch
      end
    end
  end

  describe 'map' do
    let(:repr) { [['thx1137', 'star wars'], ['42', 'hitchhiker']] }
    it 'iterates over the raw table' do
      expect(table.map(&:first)).to eq ['thx1137', '42']
    end
  end

  describe 'map_column!' do
    let(:repr) { [['name', 'age'], ['Jeff', '43'], ['Kasira', '32']] }
    it 'iterates through the column value and assigns it the value returned by the block' do
      table.map_column!(:age) { |age| age.to_i }
      expect(table.rows).to eq [['Jeff', 43], ['Kasira', 32]]
    end

    context 'with undefined column' do
      it 'raies an error' do
        expect { table.map_column!(:undefined){} }.to raise_error Satisfy::ColumnDoesNotExist
      end
      it 'not raises an error when the strict param is false' do
        expect { table.map_column!(:undefined, false){} }.to_not raise_error
      end
    end
  end

  describe 'to_a' do
    it 'returns the raw table' do
      expect(table.to_a).to eq [['answer', 'source'], ['42', 'hitchhiker']]
    end
  end
end
