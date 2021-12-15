require 'minitest/autorun'
require_relative './whale_escape_solution.rb'

describe EscapePlan do

  it 'calculates minimum alignment of the positions' do
    plan = EscapePlan.new([16,1,2,0,4,2,7,1,2,14])

    assert_equal(2, plan.optimal_position,
      "Should be set to 2")
  end

  it 'calculates fuel cost for optimum position.' do
    plan = EscapePlan.new([16,1,2,0,4,2,7,1,2,14])

    assert_equal(37, plan.optimal_fuel_cost,
      "Should be calculated to 37")
  end
end


describe EscapePlan2 do

  it 'calculates minimum alignment of the positions' do
    plan = EscapePlan2.new([16,1,2,0,4,2,7,1,2,14])

    assert_equal(5, plan.optimal_position,
      "Should be set to 5")
  end

  it 'calculates fuel cost for optimum position.' do
    plan = EscapePlan2.new([16,1,2,0,4,2,7,1,2,14])

    assert_equal(168, plan.optimal_fuel_cost,
      "Should be calculated to 168")
  end
end
