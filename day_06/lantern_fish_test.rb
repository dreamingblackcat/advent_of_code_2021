require 'minitest/autorun'
require_relative './lantern_fish_solution.rb'

describe LaternFish do

  it 'calculates the number of fish that will be produced by a fish after a number of days' do
    fish = LaternFish.new(initial_timer: 6, born_at: 0)

    (1..7).each do |day|
      fish.breed(day)
    end
    assert_equal(1, fish.direct_descendents.count,
      "Should have an initial descendent count.")
    assert_equal(2, fish.total_family,
      "Should have an initial descendent count.")

    (8..14).each do |day|
      fish.breed(day)
    end
    assert_equal(2, fish.direct_descendents.count,
      "Should have an initial descendent count.")
    assert_equal(3, fish.total_family,
      "Should have an initial descendent count.")

    (15..19).each do |day|
      fish.breed(day)
    end

    assert_equal(2, fish.direct_descendents.count,
      "Should still have 2 direct descendents count.")
    assert_equal(4, fish.total_family,
      "Should have an initial descendent count.")
  end

end

describe LanternFishBreeder do
  it 'calculates total number of fish that will be produced by a given list of fish after a number of days' do
    breeder = LanternFishBreeder.new([3,4,3,1,2])
    total = breeder.total_family_after(18)

    assert_equal(26, total,
      "Should have 26 descendent.")

    breeder = LanternFishBreeder.new([3,4,3,1,2])
    total = breeder.total_family_after(80)

    assert_equal(5934, total,
      "Should have 5934 descendent.")
  end
end
