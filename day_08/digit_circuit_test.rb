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
  before do
    signal_observations = %w(acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab)
    output_values = %w(cdfeb fcadb cdfeb cdbaf)
    @mechanic = WireMechanic.new(signal_observations, output_values)
  end

  it 'can count unique digits in the ouptut.' do
    signal_observations = %w(be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb)
    output_values = %w(fdgacbe cefdb cefbgd gcbe)
    mechanic = WireMechanic.new(signal_observations, output_values)

    assert_equal(2, mechanic.count_easy_digit_outputs,
      "Should return correct original wiring.")
  end

  it "can guess which wire should map to a wire" do
    a_wire = @mechanic.find_a
    assert_equal('d', a_wire,
      "Should correctly map d to a_wire")
  end

  it "can guess which wire should map to d & g wires" do
    dg_wires = @mechanic.find_dg
    assert_equal(['c', 'f'], dg_wires,
      "Should correctly map to c and f")
  end

  it "can guess which wire should map to b & d wires" do
    bd_wires = @mechanic.find_bd
    assert_equal(['e', 'f'], bd_wires,
      "Should correctly map to e and f")
  end

  it "can guess which wire should map to d wire" do
    d_wire = @mechanic.find_d
    assert_equal('f', d_wire,
      "Should correctly map to f")
  end

  it "can guess which wire should map to g wire" do
    g_wire = @mechanic.find_g
    assert_equal('c', g_wire,
      "Should correctly map to c")
  end

  it "can guess which wire should map to b wire" do
    b_wire = @mechanic.find_b
    assert_equal('e', b_wire,
      "Should correctly map to e")
  end

  it "can guess which wire should map to f wire" do
    f_wire = @mechanic.find_f
    assert_equal('b', f_wire,
      "Should correctly map to b")
  end

  it "can guess which wire should map to c wire" do
    c_wire = @mechanic.find_c
    assert_equal('a', c_wire,
      "Should correctly map to a")
  end

  it "can guess which wire should map to c wire" do
    e_wire = @mechanic.find_e
    assert_equal('g', e_wire,
      "Should correctly map to g")
  end

  it 'can decode a signal for unique digit' do
    signal_observations = %w(acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab)
    output_values = %w(cdfeb fcadb cdfeb cdbaf)
    @mechanic = WireMechanic.new(signal_observations, output_values)
    assert_equal(5353, @mechanic.decode,
      "Should be able to decode correct output value.")
  end
end
