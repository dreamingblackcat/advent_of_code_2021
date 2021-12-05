require 'minitest/autorun'
require_relative './bingo_squid_solution.rb'

describe GameParser do
  before do
    test_board = File.readlines('./test_board.txt', chomp: true)
    @random_draws = test_board.first

    @board1_data = test_board[2..6]
    @board2_data = test_board[8..12]
    @board3_data = test_board[14..18]
  end

  it 'parses random draws' do
    parser = GameParser.new
    parser.parse('test_board.txt')

    assert_equal(@random_draws, parser.random_draws,
      "Should parse random draws correctly.")
  end

  it 'parses random draws' do
    parser = GameParser.new
    parser.parse('test_board.txt')

    assert_equal([@board1_data, @board2_data, @board3_data], parser.boards,
      "Should parse all boards correctly.")
  end
end


describe BingoBoard do
  before do
    test_board = File.readlines('./test_board.txt', chomp: true)
    @random_draws = test_board.first

    @board1_data = test_board[2..6]
  end

  it 'supports marking.' do
    board1 = BingoBoard.new(@board1_data, 1)

    board1.mark(7)

    assert(board1.marked_numbers.include?(7),
      "Should include 7 as marked.")
  end

  it 'ignores marking of unincluded numbers' do
    board1 = BingoBoard.new(@board1_data, 1)

    board1.mark(7777)

    refute(board1.marked_numbers.include?(7777),
      "Should not include 7777 as marked.")
  end

  it 'knows winning when row wise win happens' do
    board1 = BingoBoard.new(@board1_data, 1)

    # marking all of 3rd row
    board1.mark(21)
    board1.mark(9)
    board1.mark(14)
    board1.mark(16)
    board1.mark(7)

    assert(board1.won?,
      'Should be winning.')
  end

  it 'knows winning when col wise win happens' do
    board1 = BingoBoard.new(@board1_data, 1)

    # marking all of 3rd row
    board1.mark(13)
    board1.mark(2)
    board1.mark(9)
    board1.mark(10)
    board1.mark(12)

    assert(board1.won?,
      "Should be winning.")
  end

  it 'knows unmarked numbers' do
    board1 = BingoBoard.new(@board1_data, 1)

    # marking all of 3rd row
    board1.mark(13)
    board1.mark(2)
    board1.mark(9)
    board1.mark(10)
    board1.mark(12)

    expected_unmarked_nums  = [
      22,  17, 11,  0,
      8,  23,  4, 24,
      21,  14, 16,  7,
      6,   3, 18,  5,
      1,  20, 15, 19,
    ]

    assert_equal(expected_unmarked_nums.sort, board1.unmarked_numbers.sort,
      "Should return unmarked numbers only.")
  end

end

describe BingoGame do
  before do
    test_board = File.readlines('./test_board.txt', chomp: true)
    @random_draws = test_board.first

    @board1_data = test_board[2..6]
  end

  it 'finds wining turn if exists.' do
    winning_draws = [1,22,13,17,11,0,5] # all first row
    game = BingoGame.new(BingoBoard.new(@board1_data, 1))
    game.play(winning_draws)

    assert(game.board.won?,
      "The board should have won.")

    assert_equal(5, game.first_winning_turn,
      "Should predict first winning turn correctly.")
    assert_equal(0, game.first_winning_number,
      'Should set correct first winning number.')

    assert_equal(winning_draws[0..5], game.board.marked_numbers,
      "Should have marked all the numbers until the winning number.")
  end

  it 'calculates the final score' do
    winning_draws = [1,22,13,17,11,0,5] # all first row
    game = BingoGame.new(BingoBoard.new(@board1_data, 1))
    game.play(winning_draws)

    assert_equal(236 * 0, game.final_score,
      "Should return correct final score.")
  end
end

describe SquidCheater do
  it 'picks the winning board' do
    cheater = SquidCheater.new('test_board.txt')
    cheater.simulate

    assert_equal(3, cheater.first_winning_board.id,
      "Should select correct winning board")
    assert_equal(4512, cheater.first_winning_board_score,
      "Should calculate the winning board score.")
  end
end

describe SquidSupporter do
  it 'picks the winning board' do
    supporter = SquidSupporter.new('test_board.txt')
    supporter.simulate

    assert_equal(2, supporter.last_winning_board.id,
      "Should select correct winning board")
    assert_equal(1924, supporter.last_winning_board_score,
      "Should calculate the winning board score.")
  end
end
