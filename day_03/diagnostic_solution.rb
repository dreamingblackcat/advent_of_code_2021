class SubmarineDiagnostic
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def power_consumption
    gamma_rate_decimal * epsilon_rate_decimal
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
end

if __FILE__ == $PROGRAM_NAME
  report = File.readlines('diagnostic_input.txt', chomp: true)

  puts "Submarine diagnostic: power consumption is #{SubmarineDiagnostic.new(report).power_consumption}"
end
