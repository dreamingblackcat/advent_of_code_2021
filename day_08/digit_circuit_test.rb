require 'minitest/autorun'
require_relative './digit_circuit_solution.rb'

describe SingleDigitDisplay do

  it 'can determines digit based on wires' do
    display = SingleDigitDisplay.new

    assert_equal(1, display.get_digit('cf'),
      'Should return 1 for cf')
  end

  it 'can determines wires based on digits' do
    display = SingleDigitDisplay.new

    assert_equal('abcdefg', display.get_wires(8),
      'Should return abcdefg for 8')
  end

  it 'can guess a digit based on a given set of wires if guessable' do
    display = SingleDigitDisplay.new

    assert_equal([7], display.guess_digits_by_length('dab'),
                 'Should return 7 because only 7 has 3 wires.')
    assert_equal([1], display.guess_digits_by_length('af'),
                 'Should return 1 because only 1 has 2 wires.')
    assert_equal([4], display.guess_digits_by_length('afeg'),
                 'Should return 4 because only 1 has 4 wires.')
    assert_equal([8], display.guess_digits_by_length('abcdefg'),
                 'Should return 8 because only 1 has 7 wires.')
  end

  it 'can guess a digit based on a given set of wires if guessable' do
    display = SingleDigitDisplay.new

    assert_equal([2, 3, 5], display.guess_digits_by_length('dabce'),
                 'Should return [2,3,5] because only they all have 5 wires.')
    assert_equal([], display.guess_digits_by_length('dabcefgh'),
                 'Should return [] because no digit has 8 wires.')
  end
end

describe 'WireMechanic' do
  it 'can calculate correct wiring based on signal observation.' do
    signal_observations = %w(be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb)
    output_values = %w(fdgacbe cefdb cefbgd gcbe)

    mechanic = WireMechanic.new(signal_observations, output_values)

    assert_equal(2, mechanic.count_easy_digit_outputs,
      "Should return correct original wiring.")
  end
end
