require_relative "dtree"
require "test/unit"

class TestDTree < Test::Unit::TestCase
  def test_add_match
    values = ["fred", "barney", "wilma", "betty"]
    d = DTree.new(*values)
    values.each { |s| assert_true(d.match(s), s)}
    ["", "barneyx", "barn", "foo"].each { |s| assert_false(d.match(s), s)}
  end

  def test_find
    d = DTree.new("hello", "world")
    assert_equal([0,5], d.find_in("hello-there"))
    assert_equal([17,5], d.find_in("somewhere-in-the-world-is-something"))
    assert_nil(d.find_in("something or other"))
  end

  def test_digits
    d = DTree.new(
      [:digits]+"begin".chars(),
      "end".chars()+[:digits],
      "mid".chars() +[:digits] + "dle".chars(),
    )
    ["0begin", "end99", "mid000dle","123begin"].each { |s| assert_true(d.match(s), s)}
    ["begin", "middle", "end", "", "xxbegin", "endyy"].each { |s| assert_false(d.match(s), s)}
  end
end
