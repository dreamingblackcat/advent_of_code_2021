
class LaternFish
  attr_reader :direct_descendents
  def initialize(initial_timer:, born_at:)
    @initial_timer = initial_timer
    @born_at = born_at
    @last_child_birth = nil
    @direct_descendents = []
    @logs = []
  end

  def breed(day)
    @logs << "Breed attempted: #{day}"

    relative_day = day - (@last_child_birth || @born_at)

    @direct_descendents.each do |desc_fish|
      desc_fish.breed(day)
    end
    @logs << "breed check: #{relative_day} / #{current_rate(relative_day)} = #{relative_day % current_rate(relative_day) == 0}"
    if relative_day % current_rate(relative_day) == 0
      @logs << "New desc born. #{relative_day}"
      @direct_descendents << LaternFish.new(initial_timer: 8, born_at: day)
      @last_child_birth = day
    end
  end

  def total_family
    1 + @direct_descendents.sum(&:total_family)
  end

  private

  def current_rate(relative_day)
    if @last_child_birth.nil?
      @initial_timer + 1
    else
      7
    end
  end
end


class LanternFishBreeder
  attr_reader :fish_school

  def initialize(timers)
    @fish_school = timers.map do |timer|
      LaternFish.new(initial_timer: timer, born_at: 0)
    end
  end

  def total_family_after(days)
    (1..days).each do |day|
      @fish_school.each {|fish| fish.breed(day) }
    end

    @fish_school.sum(&:total_family)
  end
end

module AlgorithmicSolution

  @cache = {}

  def self.total_fish(initial_remaining_days, target_days)
    cache_key = "#{initial_remaining_days}:#{target_days}"
    return @cache[cache_key] unless @cache[cache_key].nil?

    if target_days < initial_remaining_days
      return 0
    end

    total = 1
    target_days -= initial_remaining_days
    while target_days >= 7
      total += 1 + total_fish(9, target_days)
      target_days -= 7
    end

    @cache[cache_key] = total
    total
  end

end

def procedural_math_solution(inputs, days)
  total = 0
  inputs.each do |timer|
    total += 1 + AlgorithmicSolution.total_fish(timer + 1, days)
  end

  total
end


def oo_simulation_solution(inputs, days)
  breeder = LanternFishBreeder.new(inputs)
  breeder.total_family_after(days)
end

if __FILE__ == $PROGRAM_NAME
  inputs = File.readlines('lantern_fish_input.txt', chomp: true).first.split(",").map(&:to_i)
  puts "Total number of fish after 80 days => #{procedural_math_solution(inputs, 80)}"
  puts "Total number of fish after 256 days => #{procedural_math_solution(inputs, 256)}"

  # Simulation solutions. Slow ones
  # puts "Total number of fish after 80 days => #{oo_simulation_solution(inputs, 80)}"
  # puts "Total number of fish after 256 days => #{oo_simulation_solution(inputs, 256)}"
end
