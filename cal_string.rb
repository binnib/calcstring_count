# cal_string.rb

class CalString
  def initialize(input)
    # Capture inpu tinto instance variable to use in another methods
    @input = input
  end

  # Method will first identify the numbers from input and handle error if any
  def add
    numbers = extract_numbers(@input)
    negatives = numbers.select { |n| n < 0 }

    unless negatives.empty?
      raise ArgumentError, "negative numbers not allowed #{negatives.join(',')}"
    end

    sum = numbers.sum
    puts "Total value is #{sum}"
    sum
  end


  private

  def extract_numbers(input)
    # here, defining default delimiters using regex
    delimiter = /,|\n/

    # here, if different delimited is provided, extract it.
    if input.start_with?("//")
      parts = input.split("\n", 2)
      custom_delimiter = parts[0][2..-1]
      delimiter = Regexp.escape(custom_delimiter)
      input = parts[1]
    end

    input.split(/#{delimiter}/).map(&:to_i)
  end
end


# expected to get 0 sum
cal = CalString.new("")
cal.add

# expected to get 1 sum
cal = CalString.new("1")
cal.add

# expected to get 6 sum
cal = CalString.new("1,5")
cal.add


#Test cases

# test_cal_string.rb

require 'minitest/autorun'
require_relative 'cal_string'

class CalStringTest < Minitest::Test
  def test_add_with_two_numbers
    cal = CalString.new("3,7")
    assert_equal 10, cal.add
  end

  def test_add_with_multiple_numbers
    cal = CalString.new("1,2,3,4,5")
    assert_equal 15, cal.add
  end

  def test_add_with_single_number
    cal = CalString.new("10")
    assert_equal 10, cal.add
  end

  def test_add_with_empty_string
    cal = CalString.new("")
    assert_equal 0, cal.add
  end

  def test_add_with_non_numeric_values
    cal = CalString.new("1,a,3")
    assert_equal 4, cal.add  # 'a' becomes 0 with to_i
  end

  def test_add_with_new_line
    cal = CalString.new("1\n2,3")
    assert_equal 6, cal.add  # 'a' becomes 0 with to_i
  end

  def test_add_with_delimiters
    cal = CalString.new("//;\n1;2")
    assert_equal 3, cal.add  # 'a' becomes 0 with to_i
  end

   def test_add_raises_error_on_negative_numbers
    cal = CalString.new("1,-2,3,-4")
    error = assert_raises(ArgumentError) { cal.add }
    assert_equal "negative numbers not allowed -2,-4", error.message
  end
end
