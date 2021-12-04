
require 'minitest/autorun'
require_relative './submarine_solution.rb'

describe Submarine do
  it 'increases the horizontal position when forward command is given' do
    sub = Submarine.new

    sub.process_command('forward', 2)

    assert_equal(2, sub.horizontal_position,
      "Should increase the horizontal_position by 2.")
  end

  it 'decreases the depth when up command is given' do
    sub = Submarine.new

    sub.process_command('up', 2)

    assert_equal(-2, sub.depth,
      "Should decrease the depth by 2.")
  end

  it 'increases the depth when down command is given' do
    sub = Submarine.new

    sub.process_command('down', 2)

    assert_equal(2, sub.depth,
      "Should increase the depth by 2.")
  end

  it 'gives the position correctly' do
    sub = Submarine.new(depth: 2, horizontal_position: 2)

    assert_equal(4, sub.position,
      "Should give the multiplication of depth and horizonatal position.")
  end

end

###################################

describe SubCommander do
  it 'processes the commands and give the position correctly.' do
    commands = [
      'forward 2',
      'up 4',
      'down 3'
    ]
    final_position = SubCommander.process(commands)

    assert_equal(-2, final_position,
      "Should be set to 2 * -1 => 2")
  end
end
