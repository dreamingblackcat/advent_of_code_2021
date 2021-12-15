class EscapePlan

  def initialize(positions)
    @positions = positions
  end

  def optimal_position
    # Optimal position is the median of the list which is essentially mid-point of all list items
    find_median(@positions.sort)
  end

  def optimal_fuel_cost
    @positions.map {|pos| horizontal_distance(pos, optimal_position) }.sum
  end

  private

  def find_median(sorted_list)
    total_size = sorted_list.size

    if total_size.even?
      first_mid = total_size / 2
      second_mid = first_mid - 1
      (sorted_list[first_mid] + sorted_list[second_mid] ) / 2
    else
      mid = total_size / 2
      sorted_list[mid]
    end
  end

  def horizontal_distance(x1, x2)
    (x1 - x2).abs
  end

end


class EscapePlan2

  def initialize(positions)
    @positions = positions
  end

  def optimal_position
    return @optimal_position unless @optimal_position.nil?

    sorted_list = @positions.sort
    avg = find_average(@positions)

    candidate_1 = avg.ceil
    candidate_2 = avg.floor

    # Optimal position is the average of the sum of all positions because it's the min possible value for all positions to converge.
    # If the average is a float then we can either take the one below or above.
    # However, I don't know a sure way to figure out which one is correct.
    # So, my hack is to calcualte fuel cost for both and choose the lower one.
    total_fuel_cost_1 = fuel_cost_for_all_crabs(candidate_1)
    total_fuel_cost_2 = fuel_cost_for_all_crabs(candidate_2)
    if total_fuel_cost_1 == total_fuel_cost_2
      @optimal_position = candidate_1 # This means the avg is exactly right. Both candidate 1 and 2 are the same pos.
      @optimal_fuel_cost = total_fuel_cost_1 # This means the avg is exactly right. Both candidate 1 and 2 are the same pos.
    elsif total_fuel_cost_1 > total_fuel_cost_2
      @optimal_position = candidate_2
      @optimal_fuel_cost = total_fuel_cost_2
    else
      @optimal_position = candidate_1
      @optimal_fuel_cost = total_fuel_cost_1
    end

    @optimal_position
  end

  def optimal_fuel_cost
    return @optimal_fuel_cost unless @optimal_fuel_cost.nil?

    optimal_position
    @optimal_fuel_cost
  end

  private

  def fuel_cost_for_all_crabs(candidate_position)
    @positions.map {|pos| fuel_cost_for_single_crab(pos, candidate_position) }.sum
  end

  def fuel_cost_for_single_crab(starting_pos, target_pos)
    sum_upto_n(horizontal_distance(starting_pos, target_pos))
  end

  def find_average(list)
    list.sum(0.0) / list.size
  end

  def find_nearest_element_before(list, number)
    return list.select {|i| i < number}.each_cons(2).map {|prev, i| (prev - i).abs }.sum
    list.take_while {|i| i <= number }.last
  end

  def find_nearest_element_after(list, number)
    return list.select {|i| i > number}.each_cons(2).map {|prev, i| (prev - i).abs }.sum
    return list.select {|i| i > number}.sum
    return list.max
    list.drop_while {|i| i < number }.first
  end

  def horizontal_distance(x1, x2)
    (x1 - x2).abs
  end

  def sum_upto_n(n)
    # sum of first n natural numbers can be calculted by Gauss's formula https://en.wikipedia.org/wiki/Carl_Friedrich_Gauss#Anecdotes
    # n(n+1) / 2
    # This saves traversing through the list and accumulating the fuel cost. :D
    (n * (n + 1)) / 2
  end

end


if __FILE__ == $PROGRAM_NAME
  inputs = File.readlines('whale_escape_input.txt', chomp: true).first.split(",").map(&:to_i)
  plan = EscapePlan.new(inputs)
  plan2 = EscapePlan2.new(inputs)

  puts "Optimal position for aligning the crab with naive understanding is: #{plan.optimal_position}"
  puts "Optimal fuel cost for aligning the crab with naive understanding at #{plan.optimal_position}: #{plan.optimal_fuel_cost}"

  puts "Optimal position for aligning the crab with actual understanding is: #{plan2.optimal_position}"
  puts "Optimal fuel cost for aligning the crab with actual understanding at #{plan2.optimal_position}: #{plan2.optimal_fuel_cost}"
end
