# frozen_string_literal: true

# Implements methods for getting weighted random samples with and without replacement,
# as well as regular random samples
class Hash
  ##
  # Choose a random key=>value pair or *n* random pairs from the hash.
  #
  # @return [Hash] new Hash containing sample key=>value pairs
  #
  # Each element doesn't includes more than once.
  #
  # If the hash is empty it returns an empty hash.
  #
  # If the hash contains less than *n* unique keys, the copy of whole hash
  # will be returned, none of keys will be lost.
  #
  def sample(number = 1)
    to_a.sample(number).to_h
  end

  alias samples sample

  ##
  # Choose 1 or n random keys from the hash, according to weights defined in hash values
  # (weighted random sampling *with* *replacement*)
  #
  # @overload weighted_choice
  #   @return [Object] one sample object
  # @overload weighted_choices(n)
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
  #     p {'_' => 9, 'a' => 1}.weighted_choices(10)  # ["_", "a", "_", "_", "_", "_", "_", "_", "_", "_"]
  #
  def weighted_choice
    weighted_choices(1).first
  end

  def weighted_choices(number = 1)
    return [] if empty?

    validate_weights
    Array.new(number) { _wrs.first }
  end

  alias wchoices weighted_choices
  alias wchoice weighted_choice

  ##
  # Choose 1 or _number_ of *distinct* random keys from the hash, according to
  # weights defined in hash values (weighted random sampling *without* *replacement*)
  #
  # @overload weighted_sample
  #   @return [Object] one sample object
  # @overload weighted_samples(number)
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
  #     {'a' => 98, 'b' => 1, 'c' => 1}.weighted_sample      # 'a'
  #     {'a' => 98, 'b' => 1, 'c' => 1}.weighted_samples(3)  # ['a', 'a', 'a']
  #     {'_' => 9, 'a' => 1}.weighted_samples(10)            # ['_', 'a']
  #
  def weighted_sample
    weighted_samples(1).first
  end

  def weighted_samples(number = 1)
    return [] if empty?

    validate_weights
    _wrs(number).map(&:first)
  end

  alias wsamples weighted_samples
  alias wsample weighted_sample

  private

  # internal method to validate parameters
  def validate_weights
    sum_weights = 0
    each_value do |weight|
      raise ArgumentError, "Invalid weight: #{weight}. All weights must be numeric." unless weight.is_a? Numeric

      sum_weights += weight if weight.positive?
    end
    raise ArgumentError, 'At least one weight should be > 0' unless sum_weights.positive?
  end

  # Returns the *number* of key-value pairs, implementing weighted random sampling.
  def _wrs(*number)
    max_by(*number) { |_, weight| weight.positive? ? rand**(1.0 / weight) : 0 }
  end
end
