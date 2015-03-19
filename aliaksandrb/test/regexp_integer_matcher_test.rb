require './lib/regexp_integer_matcher'
require 'minitest/autorun'

class RegexpTest < Minitest::Unit::TestCase
  def test_method_implemented
    assert Regexp.respond_to? :build
  end

  def test_should_accept_at_least_one_argument
    assert_raises(ArgumentError) { Regexp.build }
  end

  def test_should_return_regexp_object
    assert_instance_of Regexp, Regexp.build(1)
  end

  def test_should_accept_only_integers_and_ranges_of_integers
    assert_instance_of Regexp, Regexp.build(1, 0, -1)
    assert_instance_of Regexp, Regexp.build(1..10, -10..-5)
    assert_instance_of Regexp, Regexp.build(1, 1..10, 2)

    assert_raises(TypeError) { Regexp.build('1') }
    assert_raises(TypeError) { Regexp.build(1.0) }
    assert_raises(TypeError) { Regexp.build([1, 2, 3]) }
    assert_raises(TypeError) { Regexp.build('a'..'z') }

    assert_raises(TypeError) { Regexp.build(1, '-1') }
    assert_raises(TypeError) { Regexp.build(1, 'a'..'z') }
    assert_raises(TypeError) { Regexp.build(1, 1..10, 'a'..'z', '1') }
  end

  def test_should_match_only_integers_in_the_set_of_passed_arguments
    lucky = Regexp.build(3, 7)

    assert_match lucky, '7'
    assert_match lucky, '3'
    assert_no_match lucky, '13'
  end

  def test_should_match_only_integers_in_the_range_provided
    month = Regexp.build(1..12)
    day   = Regexp.build(1..31)
    num   = Regexp.build(0..1_000_000)

    assert_no_match month, '0'
    assert_match month, '1'
    assert_match month, '12'

    assert_match day, '6'
    assert_match day, '16'
    assert_no_match day, 'Tues'

    assert_no_match num, '-1'
  end

  def test_should_match_only_integers_accepting_mixed_arguments
    year = Regexp.build(98, 99, 2000..2005)

    assert_no_match year, '04'
    assert_match year, '2004'
    assert_match year, '99'
  end

  def test_should_match_negative_integers
    regexp = Regexp.build(-15, 5, -10..1)

    assert_match regexp, '-15'
    assert_match regexp, '-8'
    assert_match regexp, '0'

    assert_no_match regexp, '2'
    assert_no_match regexp, '15'
    assert_no_match regexp, '-'
  end

  def test_should_not_match_mixed_arguments_on_long_strings
    regexp = Regexp.build(2, -5..1, 5..10)

    assert_no_match regexp, 'he2llo'
    assert_no_match regexp, '2bye6'
    assert_no_match regexp, '2-44'
    assert_no_match regexp, '-0'

    assert_match regexp, '0'
  end

  private

  def assert_no_match(regexp, string, msg = nil)
    assert_instance_of(Regexp, regexp, 'The first argument to assert_no_match should be a Regexp.')
    self._assertions -= 1
    msg = message(msg) { "<#{mu_pp(regexp)}> expected to not match\n<#{mu_pp(string)}>" }
    assert(regexp !~ string, msg)
  end
end
