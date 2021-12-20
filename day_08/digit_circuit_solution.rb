class SingleDigitDisplay

  WIRE_MAPPING = {
    'cf'      => 1,
    'acf'     => 7,
    'bcdf'    => 4,
    'acdeg'   => 2,
    'acdfg'   => 3,
    'abdfg'   => 5,
    'abcefg'  => 0,
    'abcdfg'  => 9,
    'abdefg'  => 6,
    'abcdefg' => 8,
  }

  def get_digit(wires)
    WIRE_MAPPING[wires.chars.sort.join]
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
    @signals_by_length = @observations.map(&:chars).group_by {|x| x.length }
    @output_values = output_values
    @calculated_circuit = {}
    @digital_display = SingleDigitDisplay.new
  end

  def decode
    "abcdefg".chars.each do|char|
      @calculated_circuit[self.send("find_#{char}")] = char
    end
    output = @output_values.map do |signals|
      actual_wires = signals.chars.map {|char| @calculated_circuit[char] }.join
      @digital_display.get_digit(actual_wires)
    end.join
    output.to_i(10)
  end

  def count_easy_digit_outputs
    @output_values.select {|signal_wires| is_unique_digit_singal?(signal_wires) }.count
  end

  def find_a
    @a ||= (@signals_by_length[3].first - @signals_by_length[2].first).first
  end

  def find_dg
    @dg unless @dg.nil?

    set1, set2, set3 = @signals_by_length[5]
    @dg = ((set1 & set2 & set3) - [find_a]).sort
  end

  def find_bd
    @bd ||= (@signals_by_length[4].first - @signals_by_length[2].first)
  end

  def find_d
    @d = (find_bd & find_dg).first
  end

  def find_g
    @g = (find_dg - [find_d]).first
  end

  def find_b
    @b = (find_bd - [find_d]).first
  end

  def find_abfg
    @abfg unless @abfg.nil?

    set1, set2, set3 = @signals_by_length[6]
    @abfg = (set1 & set2 & set3)
  end

  def find_f
    @f ||= (find_abfg - [find_a,  find_b, find_g]).first
  end

  def find_c
    @c ||= (@signals_by_length[3].first - [find_a, find_f]).first
  end

  def find_e
    @e ||= (@signals_by_length[7].first - [find_a, find_b, find_c, find_d, find_f, find_g]).first
  end

  private

  def is_unique_digit_singal?(signal_wires)
    guessed_digits = @digital_display.guess_digits_by_length(signal_wires)
    (guessed_digits & [1, 4, 7, 8]).any?
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
  solution2 = inputs.map {|input| WireMechanic.new(input[:signals], input[:outputs]).decode }.sum

  puts "The total number of output values that are either of 1,4,7,8 in input is: #{solution1}"
  puts "The total sum of correct number outputs: #{solution2}"
end
