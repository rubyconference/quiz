require 'set'

class RangeRegexp
  def initialize(range)
    @min = range.first
    @max = range.last

    @negative_subpatterns = []
    @positive_subpatterns = []

    init_negative_subpatterns
    init_positive_subpatterns
  end

  def regexp
    @regexp ||= begin
      negative_subpatterns_only = arrays_diff(@negative_subpatterns, @positive_subpatterns).map do |pattern|
        "-#{pattern}"
      end
      positive_subpatterns_only = arrays_diff(@positive_subpatterns, @negative_subpatterns)
      intersected_subpatterns = (@positive_subpatterns & @negative_subpatterns).map do |pattern|
        "-?#{pattern}"
      end
      "(#{(negative_subpatterns_only + intersected_subpatterns + positive_subpatterns_only).join('|')})"
    end
  end

  private

  def arrays_diff(a, b)
    a - (a & b)
  end

  def init_negative_subpatterns
    if @min < 0
      @negative_subpatterns = split_to_patterns(@max < 0 ? @max.abs : 1, @min.abs)
      @min = 0
    end
  end

  def init_positive_subpatterns
    if @max >= 0
      @positive_subpatterns = split_to_patterns(@min, @max)
    end
  end

  def split_to_patterns(min, max)
    subpatterns = []
    start = min
    split_to_ranges(min, max).each do |stop|
      subpatterns.push(range_to_pattern(start, stop))
      start = stop + 1
    end
    subpatterns
  end

  def split_to_ranges(min, max)
    stops = Set.new
    stops.add(max)

    nines_count = 1
    stop = fill_by_nines(min, nines_count)
    while min <= stop && stop < max
      stops.add(stop)
      nines_count += 1
      stop = fill_by_nines(min, nines_count)
    end

    zeros_count = 1
    stop = fill_by_zeros(max + 1, zeros_count) - 1
    while min < stop && stop <= max
      stops.add(stop)
      zeros_count += 1
      stop = fill_by_zeros(max + 1, zeros_count) - 1
    end
    stops.to_a.sort
  end

  def fill_by_nines(int, nines_count)
    "#{int.to_s[0...-nines_count]}#{'9' * nines_count}".to_i
  end

  def fill_by_zeros(int, zeros_count)
    int - int % 10 ** zeros_count
  end

  def range_to_pattern(start, stop)
    pattern = ''
    any_digit_count = 0

    start.to_s.split('').zip(stop.to_s.split('')).each do |(start_digit, stop_digit)|
      if start_digit == stop_digit
        pattern += start_digit
      elsif start_digit != '0' || stop_digit != '9'
        pattern += "[#{start_digit}-#{stop_digit}]"
      else
        any_digit_count += 1
      end
    end

    pattern += '\d' if any_digit_count > 0
    pattern += "{#{any_digit_count}}" if any_digit_count > 1

    pattern
  end
end

class Regexp
  def self.build(*args)
    res = []
    integers = Set.new
    ranges = Set.new

    args.each do |arg|
      case arg
      when Integer
        integers.add(arg)
      when Range
        ranges.add(arg)
      else
        raise ArgumentError, "#{arg} must be Integer or Range"
      end
    end

    res += integers.to_a
    res += ranges.map { |range| RangeRegexp.new(range).regexp }

    new("^#{res.join('|')}$")
  end
end

exit unless $PROGRAM_NAME == __FILE__

# Some tests for the code above.
# To run the test use the following command: ruby regexp_build.rb
require 'minitest/autorun'

describe Regexp do
  describe '.build' do
    it 'accepts only ranges of integers or integers' do
      Regexp.build(1, 2)
      Regexp.build(1, 1..2, 2...6)

      assert_raises ArgumentError do
        Regexp.build('1', 2)
      end

      assert_raises ArgumentError do
        Regexp.build('1')
      end
    end

    it 'correctly does the match' do
      lucky = Regexp.build(3, 7)
      assert_match_regexp('7', lucky)
      refute_match_regexp('13', lucky)
      assert_match_regexp('3', lucky)

      month = Regexp.build(1..12)
      refute_match_regexp('0', month)
      assert_match_regexp('1', month)
      assert_match_regexp('12', month)

      day = Regexp.build(1..31)
      refute_match_regexp('Tues', day)
      assert_match_regexp('6', day)
      assert_match_regexp('16', day)

      year = Regexp.build(98, 99, 2000..2005)
      refute_match_regexp('04', year)
      assert_match_regexp('2004', year)
      assert_match_regexp('99', year)

      num = Regexp.build(0..1_000_000)
      refute_match_regexp('-1', year)

      empty = Regexp.build(-1, 0)
      assert_match_regexp '-1', empty
      assert_match_regexp '0', empty

      negative1 = Regexp.build(-19..19)
      assert_match_regexp '0', negative1
      assert_match_regexp '-19', negative1
      assert_match_regexp '-1', negative1
      assert_match_regexp '1', negative1
      assert_match_regexp '19', negative1
      refute_match_regexp '20', negative1
      refute_match_regexp '-20', negative1

      negative2 = Regexp.build(-19..-15)
      assert_match_regexp '-19', negative2
      assert_match_regexp '-15', negative2
      refute_match_regexp '-13', negative2
      refute_match_regexp '-20', negative2
      refute_match_regexp '-14', negative2
    end

    def assert_match_regexp(str, regexp)
      assert_equal true, !!(str =~ regexp)
    end

    def refute_match_regexp(str, regexp)
      assert_equal false, !!(str =~ regexp)
    end
  end
end
