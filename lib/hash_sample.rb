# monkey-patched Hash module
class Hash
  ##
  # Choose a random key=>value pair or *n* random pairs from the hash.
  #
  # @return [Hash] new Hash containing sample key=>value pairs
  #
  # The elements are chosen by using random and unique indices in order to ensure that each element doesn't includes more than once.
  # If the hash is empty it returns an empty hash.
  # If the hash contains less than *n* unique keys, the copy of whole hash will be returned, none of keys will be lost.
  def sample(n = 1)
    to_a.sample(n).to_h
  end

  ###
  # alias for wchoice
  def wchoices(*args)
    wchoice(*args)
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
    n = args.first || 1
    res = []
    n.times do
      tmp = max_by { |_, weight| weight.positive? ? rand**(1.0 / weight) : 0 }
      res << tmp.first unless tmp.nil?
    end
    return args.empty? ? res.first : res
  end

  # internal method to validate parameters
  def _check_weighted_params(*_args)
    sum_weights = 0
    each_value do |v|
      raise ArgumentError, "All weights should be numeric unlike #{v}" unless v.is_a? Numeric

      sum_weights += v if v.positive?
    end

    raise ArgumentError, "At least one weight should be > 0" unless sum_weights.positive? || empty?
  end

  ##
  # Choose 1 or n *distinct* random keys from the hash, according to weights defined in hash values 
  # (weighted random sampling *without* *replacement*)
  #
  # @overload wsample
  #   @return [Object] one sample object
  # @overload wsample(n)
  #   @param n [Integer] number of samples to be returned
  #   @return [Array] Array of n or sometimes less than n samples
  #
  # When there are no sufficient distinct samples to return, the result will contain less than n samples
  # If the hash is empty the first form returns nil and the second form returns an empty array.
  # All weights should be Numeric.
  # Zero or negative weighs will be ignored.
  #
  # ===== Example
  #
  #     p {'_' => 9, 'a' => 1}.wsample(10)  # ["_", "a"]
  #
  def wsample(*args)
    _check_weighted_params
    n = args.first || 1
    res = max_by(n) { |_, weight| weight.positive? ? rand**(1.0 / weight) : 0 }.map(&:first)
    return args.empty? ? res.first : res
  end

  ###
  # alias for wsample
  def wsamples(*args)
    wsample(*args)
  end
end
