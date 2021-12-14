class EscapePlan

  def initialize(positions)
    @positions = positions
  end

  def optimal_position
    total_count = @positions.count
    sorted_positions = @positions.sort
    if total_count.even?
      first_mid = total_count / 2
      second_mid = first_mid - 1
      (sorted_positions[first_mid] + sorted_positions[second_mid] ) / 2
    else
      mid = total_count / 2
      sorted_positions[mid]
    end
  end

  def optimal_fuel_cost
    @positions.map {|i| (i - optimal_position).abs }.sum
  end

end


class EscapePlan2

  def initialize(positions)
    @positions = positions
  end

  def optimal_position
    avg = (@positions.sum(0.0) / @positions.size)

    max = @positions.bsearch {|i| i >= avg }
    min = @positions.bsearch {|i| i <= avg }

   if (max - avg).abs > (min - avg).abs
    avg.ceil
   else
    avg.floor
   end
  end

  def optimal_fuel_cost
    @positions.map do |i|
       steps = (i - optimal_position).abs
       (steps * (steps + 1)) / 2
    end.sum
  end

end


if __FILE__ == $PROGRAM_NAME
  inputs = File.readlines('whale_escape_input.txt', chomp: true).first.split(",").map(&:to_i)
  plan = EscapePlan.new(inputs)
  plan2 = EscapePlan2.new(inputs)

  puts "Optimal position for aligning the crab with naive understanding is: #{plan.optimal_position}"
  puts "Optimal fuel cost for aligning the crab with naive understanding at #{plan.optimal_position}: #{plan.optimal_fuel_cost}"

  puts "Optimal position for aligning the crab with naive understanding is: #{plan2.optimal_position}"
  puts "Optimal fuel cost for aligning the crab with naive understanding at #{plan2.optimal_position}: #{plan2.optimal_fuel_cost}"
end
