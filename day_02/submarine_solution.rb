class Submarine
  attr_reader :depth, :horizontal_position, :aim

  def initialize(depth: 0, horizontal_position: 0, aim: 0)
    @depth = depth
    @horizontal_position = horizontal_position
    @aim = aim
  end

  def process_command(command, arg)
    case command
    when 'forward'
      forward(arg)
    when 'up'
      up(arg)
    when 'down'
      down(arg)
    else
      raise "Whoops! Unknown command '#{command}'."
    end
  end

  def position
    @depth * @horizontal_position
  end

  private

  def forward(n)
    @horizontal_position += n
    @depth += @aim * n
  end

  def up(n)
    @aim -= n
  end

  def down(n)
    @aim += n
  end

end


class SubCommander
  def self.process(readings)
    submarine = Submarine.new
    readings.each do |reading|
      command, arg = reading.split(' ')
      submarine.process_command(command, arg.to_i)
    end

    submarine.position
  end
end

if __FILE__ == $PROGRAM_NAME
  commands = File.readlines('submarine_input.txt', chomp: true)

  puts "Submarine is at #{SubCommander.process(commands)}"
end
