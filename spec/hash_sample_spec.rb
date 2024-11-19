# frozen_string_literal: true

shared_examples 'weighted sampler' do |weighted_method|
  context weighted_method.to_s do
    let(:weighted_methods) { "#{weighted_method}s" }

    describe 'plural form of method' do
      it 'can be used' do
        expect(described_class.new).to respond_to(weighted_methods)
      end

      it 'works as expected without args' do
        expect({ 'a' => 1 }.send(weighted_methods)).to eq ['a']
      end

      it 'works as expected with args' do
        expect({ 'a' => 1 }.send(weighted_methods, 1)).to eq ['a']
      end
    end

    describe "Hash##{weighted_method}" do
      let(:test_hash) { { 1 => 90, 2 => 10 } }

      it 'returns weighted sample key from all keys with respect of its weights' do
        freq = described_class.new(0)
        1000.times { freq[test_hash.send(weighted_method)] += 1 }
        expect(freq[1]).to be_between(850, 950) # +-5% bias
      end

      it 'returns equal parts of samples when weights are equal' do
        res = 1.upto(100_000).to_a.map { { +1 => 50, -1 => 50 }.send(weighted_method) }
        expect(res.sum).to be_between(-1000, 1000) # +-1%  bias
      end

      it 'works with fractional weights' do
        expect([1, 2].include?({ 1 => 0.1, 2 => 0.9 }.send(weighted_method))).to be true
      end

      it 'ignores negative weights' do
        10.times { expect({ 'a' => -1, 'b' => 2 }.send(weighted_method)).to eq 'b' }
      end

      it 'ignores zero weight' do
        10.times do
          expect({ 1 => 0, 2 => 1, 3 => 0 }.send(weighted_method)).to eq 2
        end
      end

      it 'raises ArgumentError when weight is non-numeric' do
        expect { { 1 => 'asd', 2 => 2 }.send(weighted_method) }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError when all weights are zero' do
        expect { { 1 => 0, 2 => 0 }.send(weighted_method) }.to raise_error(ArgumentError)
      end

      it 'returns [] from {} if param specified' do
        expect({}.send(weighted_methods, 10)).to eq []
      end

      it 'returns [] from {} if no param specified' do
        expect({}.send(weighted_methods)).to eq []
      end

      it 'returns array for parameter > 1' do
        100.times { expect({ 1 => 1, 2 => 0.01, 3 => 0.0000001 }.weighted_choices(3).length).to be 3 }
      end

      context 'when specified parameter n==1' do
        subject(:result) { { '1' => 1, '2' => 1, '3' => 1 }.weighted_samples(1) }

        it { expect(result).to be_a(Array) }
        it { expect(result.length).to be 1 }
      end

      describe 'should work with complex Objects as keys' do
        subject(:result) do
          { test_class.new('asd') => 1, test_class.new('bsd') => 1, test_class.new('dsf') => 1 }.weighted_choice
        end

        let(:test_class) { Struct.new(:foo) }

        it 'returns array of one key' do
          expect(result).to be_a(test_class)
        end
      end
    end
  end
end

RSpec.describe Hash do
  let(:simple_hash) { { 'a' => 'x', 'b' => 'y', 'c' => 'z' } }
  let(:weighted_hash) { { 'a' => 90, 'b' => 10 } }
  let(:empty_hash) { {} }

  describe '#sample' do
    context 'when n is less than or equal to the number of unique keys' do
      subject(:result) { simple_hash.sample(2) }

      it { expect(result.keys.size).to eq(2) }
      it { expect(result).to be_a(described_class) }
    end

    context 'when n is greater than the number of unique keys' do
      subject(:result) { simple_hash.sample(10) }

      it 'returns the entire hash' do
        expect(result).to eq(simple_hash)
      end
    end

    context 'when n equals 1' do
      subject(:result) { simple_hash.sample(1) }

      it { expect(result.keys.size).to eq(1) }
      it { expect(result).to be_a(described_class) }
    end

    context 'when the hash is empty' do
      it { expect(empty_hash.sample).to eq({}) }
    end
  end

  describe '#weighted_choices' do
    it_behaves_like 'weighted sampler', :weighted_choice

    context 'when specified parameter n>1' do
      it 'returns array of n sample keys' do
        expect({ 'a' => 1 }.weighted_choices(2)).to eq %w[a a]
      end
    end

    context 'when specified parameter is greater than number of keys' do
      it 'returns array with exactly n key samples, repeating some of them' do
        h = { 'a' => 1, 'b' => 1, 'c' => 1 }
        expect(h.weighted_choices(10).length).to eq 10
      end
    end
  end

  describe '#weighted_samples' do
    it_behaves_like 'weighted sampler', :weighted_sample

    describe 'when specified parameter n>1' do
      it 'returns array of unique keys' do
        expect({ 'a' => 1 }.weighted_samples(2)).to eq ['a']
      end
    end

    context 'when specified parameter is greater than number of keys' do
      let(:sample_hash) { { 'a' => 1, 'b' => 1, 'c' => 1 } }

      it 'returns array with all presented keys' do
        expect(sample_hash.weighted_samples(100).length).to eq 3
      end
    end

    it 'returned objects are not repeated' do
      expect({ '_' => 9, 'a' => 1 }.weighted_samples(10).sort).to eq %w[_ a]
    end
  end
end
