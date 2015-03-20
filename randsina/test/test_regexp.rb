require 'minitest/autorun'
require_relative '../lib/regexp'

# Test class Regexp with a class method 'build'
class TestRegexp < Minitest::Test
  def test_that_build_return_regexp
    assert_kind_of Regexp, Regexp.build
  end

  def test_that_build_with_only_numbers
    lucky = Regexp.build(3, 7)
    assert_match lucky, '7'
    refute_match lucky, '13'
    assert_match lucky, '3'
  end

  def test_that_build_with_only_range_of_month
    month = Regexp.build(1..12)
    refute_match month, '0'
    assert_match month, '1'
    assert_match month, '12'
  end

  def test_that_build_with_only_range_of_day
    day = Regexp.build(1..31)
    assert_match day, '6'
    assert_match day, '16'
    refute_match day, 'Tues'
  end

  def test_that_build_with_numbers_and_range
    year = Regexp.build(98, 99, 2000..2005)
    refute_match year, '04'
    assert_match year, '2004'
    assert_match year, '99'
  end

  def test_that_build_with_a_big_range
    num = Regexp.build(0..1_000_000)
    refute_match num, '-1'
  end

  def test_that_build_with_ranges
    ranges = Regexp.build(1..10, 0..6)
    assert_match ranges, '0'
    assert_match ranges, '6'
    refute_match ranges, '-11'
  end
end
