class SingleDigitDisplay

  WIRE_MAPPING = {
    'abcefg' => 0,
    'cf' => 1,
    'acdeg' => 2,
    'acdfg' => 3,
    'bcdf' => 4,
    'abdfg' => 5,
    'abdefg' => 6,
    'acf' => 7,
    'abcdefg' => 8,
    'abcdfg' => 9,
  }

  def get_digit(wires)
    WIRE_MAPPING[wires]
  end

  def get_wires(digit)
    WIRE_MAPPING.invert[digit]
  end

  def guess_digits_by_length(confused_wires)
    WIRE_MAPPING.to_a.group_by {|k, v| k.length }
                     .transform_values {|val| val.map {|v| v[1]}.flatten }
                     .fetch(confused_wires.length, [])
  end

end

class WireMechanic
  def initialize(observations, output_values)
    @observations = observations
    @output_values = output_values
    @calculated_links = {}
    @digital_display = SingleDigitDisplay.new
  end

  def count_easy_digit_outputs
    @output_values.map do |signal_wires|
      guessed_digits = @digital_display.guess_digits_by_length(signal_wires)
      matched = (guessed_digits & [1, 4, 7, 8])
      matched.size
    end.sum
  end
end


if __FILE__ == $PROGRAM_NAME
  inputs = File.readlines('digit_circuit_input.txt', chomp: true)
  inputs = inputs.map do |entry|
    signals = entry.split(' | ').first.split(" ")
    outputs = entry.split(' | ').last.split(" ")
    {signals: signals, outputs: outputs}
  end
  solution1 = inputs.map {|input| WireMechanic.new(input[:signals], input[:outputs]).count_easy_digit_outputs }.sum

  puts "The total number of output values that are either of 1,4,7,8 in input is: #{solution1}"
end
