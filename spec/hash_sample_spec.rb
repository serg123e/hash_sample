# frozen_string_literal: true

#
# Specs
#
describe 'Hash#sample' do
  before :all do
    @h = { 'a' => 'b', 'b' => 'b', 'c' => 'b' }
  end

  describe 'when specified parameter n>1' do
    it 'returns new Hash with specified number of unique key=>value samples' do
      expect(@h.sample(3)).to eq @h
    end
  end
  describe 'when specified parameter n> number of unique keys' do
    it 'returns new Hash only with unique key=>value samples' do
      expect(@h.sample(10)).to eq @h
    end
  end

  describe 'when specified parameter n> number of unique keys' do
    it 'keys can not be lost because of bad luck' do
      min = @h.keys.length
      100.times do
        min = [@h.sample(4).keys.length, min].min
      end
      expect(min).to be 3
    end
  end

  describe 'when specified parameter n==1' do
    it 'returns new Hash with 1 random key=>value sample' do
      expect(@h.sample(1).keys.length).to eq 1
    end
  end
end

%w[wchoice wsample].each do |weighted_method|
  context "#{weighted_method}" do
    let(:weighted_methods) { weighted_method + "s" }

    describe 'plural form of method' do
      it 'can be used' do
        expect(Hash.new).to respond_to(weighted_methods)
      end
      it 'works as expected without args' do
        expect({ 'a' => 1 }.send(weighted_methods)).to eq ['a']
      end
      it 'works as expected with args' do
        expect({ 'a' => 1 }.send(weighted_methods, 1)).to eq ['a']
      end
    end

    describe "Hash\##{weighted_method}" do
      before :all do
        @test_hash = { 1 => 90, 2 => 10 }
      end

      it 'returns weighted sample key from all keys with respect of its weights' do
        freq = Hash.new(0)
        1000.times { freq[@test_hash.send(weighted_method)] += 1 }
        expect(freq[1]).to be_between(850, 950) # +-5% bias
      end

      describe 'when weights are equal' do
        it 'it should returns equal parts of samples' do
          res = 1.upto(100_000).to_a.map { { +1 => 50, -1 => 50 }.send(weighted_method) }
          expect(res.sum).to be_between(-1000, 1000) # +-1%  bias
        end
      end

      describe 'when weights are Float' do
        it 'returns a value as expected' do
          expect([1, 2].include?({ 1 => 0.1, 2 => 0.9 }.send(weighted_method))).to be true
        end
      end

      describe 'when some weights are negative' do
        it 'does not sample that key' do
          100.times { expect({ 'a' => -1, 'b' => 2 }.send(weighted_method)).to eq 'b' }
        end
      end

      describe 'when weight contains zero' do
        it 'returns non-zero weighted element' do
          10.times do
            expect({ 1 => 0, 2 => 1, 3 => 0 }.send(weighted_method)).to eq 2
          end
        end
      end

      describe 'when weight is non-numeric' do
        it 'raises ArgumentError' do
          expect { { 1 => 'asd', 2 => 2 }.send(weighted_method) }.to raise_error(ArgumentError)
        end
      end

      describe 'when all weights are zero' do
        it 'raises ArgumentError' do
          expect { { 1 => 0, 2 => 0 }.send(weighted_method) }.to raise_error(ArgumentError)
        end
      end

      describe 'when hash is empty' do
        it 'returns [] if param specified' do
          expect(Hash.new.send(weighted_methods, 10)).to eq []
        end
        it 'returns [] if no param specified' do
          expect(Hash.new.send(weighted_methods)).to eq []
        end
      end

      describe 'when specified parameter n>1' do
        it 'returns array of sample keys 2' do
          100.times { expect({ 1 => 1, 2 => 0.01, 3 => 0.0000001 }.weighted_choices(3).length).to be 3 }
        end
      end
      describe 'when specified parameter n==1' do
        subject { { '1' => 1, '2' => 1, '3' => 1 }.weighted_samples(1) }
        it 'returns array of one key' do
          expect(subject).to be_kind_of(Array)
          expect(subject.length).to be 1
        end
      end

      describe 'should work with complex Objetcts as keys' do
        # Complex Object for testing purpouse
        TestObject = Struct.new(:foo)

        subject { { TestObject.new('asd') => 1, TestObject.new('bsd') => 1, TestObject.new('dsf') => 1 }.wchoice }
        it 'returns array of one key' do
          expect(subject).to be_kind_of(TestObject)
        end
      end

      describe 'when specified parameter n is greater than number of unique keys' do
        it 'returns array with exactly n key samples, repeating some of them' do
          h = { 'a' => 1, 'b' => 1, 'c' => 1 }
          expect(h.weighted_choices(10).length).to eq 10
        end
      end
    end
  end
end

describe 'Hash#wchoice' do
  describe 'when specified parameter n>1' do
    it 'returns array of n sample keys' do
      expect({ 'a' => 1 }.weighted_choices(2)).to eq %w[a a]
    end
  end
end

describe 'Hash#wsample' do
  describe 'when specified parameter n>1' do
    it 'returns array of unique keys' do
      expect({ 'a' => 1 }.weighted_samples(2)).to eq ['a']
    end
  end

  it 'returned objects are not repeated' do
    expect({ '_' => 9, 'a' => 1 }.weighted_samples(10).sort).to eq %w[_ a]
  end
end
