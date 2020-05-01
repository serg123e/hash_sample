# hash_sample

[![Build Status](https://travis-ci.com/serg123e/hash_sample.svg?branch=master)](https://travis-ci.com/serg123e/hash_sample)

Implements methods for Hash class for getting weighted random samples with and without replacement, as well as regular random samples

## Installation

    gem install hash_sample

## Usage

```ruby
    require 'hash_sample'
    loaded_die = {'1' => 0.1, '2' => 0.1, '3' => 0.1, '4' => 0.1, '5' => 0.1, '6' => 0.5}
    p loaded_die.wchoice      # "6"
    p loaded_die.wchoice(1)   # ["6"]
    p loaded_die.wchoice(10)  # ["4", "6", "3", "3", "2", "2", "1", "6", "4", "6"]
    p loaded_die.wsample      # 6
    p loaded_die.wsample(6)   # ["6", "3", "2", "4", "1", "5"]
    p loaded_die.wsample(10)  # ["2", "6", "1", "3", "4", "5"]
    p loaded_die.sample       # { '1' => 0.1 }
    p loaded_die.sample(6)    # {'1' => 0.1, '2' => 0.1, '3' => 0.1, '4' => 0.1, '5' => 0.1, '6' => 0.5}
```

## Hash instance methods
### hash.sample(n = 1) ⇒ Hash
Choose a random key=>value pair or n random pairs from the hash.

The key=>value pairs are chosen by using random and unique indices in order to ensure that each pair doesn't includes more than once

If the hash is empty it returns an empty hash. 

If the hash contains less than n unique keys, the copy of whole hash will be returned, none of keys will be lost due to bad luck.

Returns new Hash containing sample key=>value pairs

### hash.wchoice ⇒ Object
### hash.wchoice(n) ⇒ Array of n samples.
Weighted random sampling *with* replacement.

Choose a random key or n random keys from the hash, according to weights defined in hash values.

The samples are drawn by using random and replaced by its copy, so they **can be repeated in result**.

If the hash is empty the first form returns nil and the second form returns an empty array.

All weights should be Numeric.

Zero or negative weighs will be ignored.

    {'_' => 9, 'a' => 1}.wchoice(10)  # ["_", "a", "_", "_", "_", "_", "_", "_", "_", "_"]

### hash.wsample ⇒ Object
### hash.wsample(n) ⇒ Array of n samples.
Weighted random sampling *without* replacement.

Choose 1 or n *distinct* random keys from the hash, according to weights defined in hash values.
Drawn items are not replaced.

If the hash is empty the first form returns nil and the second form returns an empty array.

All weights should be Numeric.

Zero or negative weighs will be ignored.

    {'_' => 9, 'a' => 1}.wchoice(10)  # ["_", "a"]

### hash.wchoices(n = 1) ⇒ Object
alias for wchoice

### hash.wsamples(n = 1) ⇒ Object
alias for wsample

## Contributing

1. Fork it ( https://github.com/serg123e/hash_sample/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## References

1. [Efraimidis and Spirakis implementation of random sampling with replacement](https://gist.github.com/O-I/3e0654509dd8057b539a)
2. [Weighted Random Sampling (2005; Efraimidis, Spirakis)](https://utopia.duth.gr/~pefraimi/research/data/2007EncOfAlg.pdf)
3. [Abandoned Ruby feature request](https://bugs.ruby-lang.org/issues/4247#change-25166)
4. [Inspiring example of using max_by for Enumerables with the same algorithm](https://ruby-doc.org/core-2.7.1/Enumerable.html#method-i-max_by)