require 'minitest/autorun'
require_relative './diagnostic_solution.rb'

describe SubmarineDiagnostic do

  before do
    @report = [
      '00100',
      '11110',
      '10110',
      '10111',
      '10101',
      '01111',
      '00111',
      '11100',
      '10000',
      '11001',
      '00010',
      '01010',
    ]
  end

  it 'takes the gamma rate correctly' do
    diagnostic = SubmarineDiagnostic.new(@report)

    assert_equal('10110', diagnostic.gamma_rate_binary,
      "Should return correct gamma rate.")
    assert_equal(22, diagnostic.gamma_rate_decimal,
      "Should return correct gamma rate.")
  end

  it 'takes the epsilon rate correctly' do
    diagnostic = SubmarineDiagnostic.new(@report)

    assert_equal('01001', diagnostic.epsilon_rate_binary,
      "Should return correct epsilon rate.")

    assert_equal(9, diagnostic.epsilon_rate_decimal,
      "Should return correct epsilon rate.")
  end

  it 'calculates power consumption' do
    diagnostic = SubmarineDiagnostic.new(@report)

    assert_equal(198, diagnostic.power_consumption,
      "Should return correct epsilon rate.")
  end

  it 'calculates oxygen geneator rating' do
    diagnostic = SubmarineDiagnostic.new(@report)

    assert_equal('10111', diagnostic.oxygen_generator_rating_binary,
      "Should return correct oxygen geneator rating in binary string.")

    assert_equal(23, diagnostic.oxygen_generator_rating_decimal,
      "Should return correct oxygen geneator rating in decimal.")
  end

  it 'calculates co2 scrubber rating' do
    diagnostic = SubmarineDiagnostic.new(@report)

    assert_equal('01010', diagnostic.co2_scrubber_rating_binary,
      "Should return correct co2 scrubber rating in binary string.")

    assert_equal(10, diagnostic.co2_scrubber_rating_decimal,
      "Should return correct co2 scrubber rating in decimal.")
  end

  it 'calculates life support rating' do
    diagnostic = SubmarineDiagnostic.new(@report)

    assert_equal(230, diagnostic.life_support_rating,
      "Should return correct life support rating.")
  end

end
