readings = File.read('sonar_sweep_input.txt').split("\n")

def solve_puzzle1(readings)
  last_reading = readings.first
  count = 0

  readings[1..].each do |reading|
    count += 1 if last_reading.to_i < reading.to_i
    last_reading = reading
  end

  puts count
end

# solve_puzzle1(readings)

def solve_puzzle2(readings)
  a, b, c = readings[0..2]
  count = 0

  readings[3..].each do |reading|
    # puts "OOps #{last_reading}:#{reading}" if last_reading.length < reading.length
    count += 1 if a.to_i + b.to_i + c.to_i < b.to_i + c.to_i + reading.to_i
    a = b
    b = c
    c = reading
  end

  puts count
end

solve_puzzle2(readings)
