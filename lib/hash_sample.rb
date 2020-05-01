# monkey-patched Hash module
class Hash
  ##
  # Choose a random key=>value pair or *n* random pairs from the hash.
  #
  # @return [Hash] new Hash containing sample key=>value pairs
  #
  # The elements are chosen by using random and unique indices in order to
  # ensure that each element doesn't includes more than once.
  #
  # If the hash is empty it returns an empty hash.
  #
  # If the hash contains less than *n* unique keys, the copy of whole hash
  # will be returned, none of keys will be lost.
  def sample(number = 1)
    to_a.sample(number).to_h
  end

  ###
  # alias for wchoice
  def wchoices(*number)
    wchoice(*number)
  end

  ##
  # Choose 1 or n random keys from the hash, according to weights defined in hash values
  # (weighted random sampling *with* *replacement*)
  #
  # @overload wchoice
  #   @return [Object] one sample object
  # @overload wchoice(n)
  #   @param n [Integer] number of samples to be returned
  #   @return [Array] Array of n samples
  #
  # The keys are chosen by using random according to its weights and *can* *be* *repeated* *in* *result*.
  # If the hash is empty the first form returns nil and the second form returns an empty array.
  # All weights should be Numeric.
  # Zero or negative weighs will be ignored.
  #
  # ===== Example
  #
  #     p {'_' => 9, 'a' => 1}.wchoice(10)  # ["_", "a", "_", "_", "_", "_", "_", "_", "_", "_"]
  #
  def wchoice(*args)
    _check_weighted_params
    number = args.first || 1
    res = []
    unless empty?
      number.times do
        tmp = _wrs
        res << tmp.first
      end
    end
    return args.empty? ? res.first : res
  end

  # internal method to validate parameters
  def _check_weighted_params
    sum_weights = 0
    each_value do |weight|
      raise ArgumentError, "All weights should be numeric unlike #{weight}" unless weight.is_a? Numeric

      sum_weights += weight if weight.positive?
    end

    raise ArgumentError, "At least one weight should be > 0" unless sum_weights.positive? || empty?
  end

  ##
  # Choose 1 or number *distinct* random keys from the hash, according to
  # weights defined in hash values (weighted random sampling *without* *replacement*)
  #
  # @overload wsample
  #   @return [Object] one sample object
  # @overload wsample(number)
  #   @param number [Integer] number of samples to be returned
  #   @return [Array] Array of specified or sometimes less than specified samples
  #
  # When there are no sufficient distinct samples to return, the result will
  # contain less than specified number of samples
  #
  # If the hash is empty the first form returns nil and the second form returns an empty array.
  # All weights should be Numeric.
  # Objects with zero or negative weighs will be skipped.
  #
  # ===== Example
  #
  #     p {'_' => 9, 'a' => 1}.wsample(10)  # ["_", "a"]
  #
  def wsample(*number)
    _check_weighted_params
    res = _wrs(number.first || 1).map(&:first)
    return number.first ? res : res.first
  end

  ###
  # alias for wsample
  def wsamples(*number)
    wsample(*number)
  end

  # internal method that implements weighted random sampling
  def _wrs(*number)
    max_by(*number) { |_, weight| weight.positive? ? rand**(1.0 / weight) : 0 }
  end
end
