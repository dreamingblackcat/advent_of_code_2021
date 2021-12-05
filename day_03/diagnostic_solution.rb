class SubmarineDiagnostic
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def power_consumption
    gamma_rate_decimal * epsilon_rate_decimal
  end

  def life_support_rating
    oxygen_generator_rating_decimal * co2_scrubber_rating_decimal
  end

  def co2_scrubber_rating_decimal
    co2_scrubber_rating_binary.to_i(2)
  end

  def co2_scrubber_rating_binary
    iterate_and_pick do |grouped_counts|
      select_by_least_common_occurence(grouped_counts)
    end
  end

  def oxygen_generator_rating_decimal
    oxygen_generator_rating_binary.to_i(2)
  end

  def oxygen_generator_rating_binary
    iterate_and_pick do |grouped_counts|
      select_by_most_common_occurence(grouped_counts)
    end
  end

  def gamma_rate_decimal
    gamma_rate_binary.to_i(2)
  end

  def epsilon_rate_decimal
    epsilon_rate_binary.to_i(2)
  end

  def gamma_rate_binary
    gamma_digits.join('')
  end

  def epsilon_rate_binary
    epsilon_digits.join('')
  end

  private

  def gamma_digits
    digits = report.first.length
    total_rows = report.length

    (0...digits).map do |pos|
      positional_sum = report.sum {|row| row[pos].to_i }
      if positional_sum > (total_rows / 2)
        1
      elsif positional_sum == (total_rows / 2)
        raise "Ooops! Ambiguous report! No most common or least common bits for pos #{pos}"
      else
        0
      end
    end
  end

  def epsilon_digits
    gamma_digits.map {|digit| digit == 1 ? 0 : 1 }
  end

  def iterate_and_pick(&candidate_bit_picker)
    total_bit_length = report.first.length
    selection = report
    pos = 0

    while pos < total_bit_length || selection.length > 1 do
      candidate_bit = candidate_bit_picker.call(count_by_occurrence(selection, pos))
      selection = selection.select {|reading| reading.chars[pos].to_i == candidate_bit }
      pos += 1
    end

    selection.first
  end

  # Uses sort order to take advantage of the fact that 0 comes first incase of tie
  def select_by_least_common_occurence(grouped_count)
    grouped_count.sort_by {|k, v| k }.min_by {|k,v| v }.first.to_i
  end

  def select_by_most_common_occurence(grouped_count)
    grouped_count.sort_by {|k, v| k }.reverse.max_by {|k,v| v }.first.to_i
  end

  def count_by_occurrence(readings, pos)
    readings.map {|reading| reading.chars[pos] }.group_by(&:itself).transform_values(&:size)
  end
end

if __FILE__ == $PROGRAM_NAME
  report = File.readlines('diagnostic_input.txt', chomp: true)
  diagnostic = SubmarineDiagnostic.new(report)

  puts "Submarine diagnostic: power consumption is #{diagnostic.power_consumption}"
  puts "Submarine diagnostic: life support rating is #{diagnostic.life_support_rating}"
end
