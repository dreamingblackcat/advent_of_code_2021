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

end
