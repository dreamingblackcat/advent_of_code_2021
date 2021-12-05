class GameParser
  attr_reader :random_draws, :boards

  def initialize
    @random_draws = ''
    @boards = []
  end

  def parse(file_name)
    lines = File.readlines(file_name, chomp: true)
    @random_draws = lines.first

    @boards = lines[1..].each_slice(6).map do |group|
      group[1..]
    end
  end
end

class BingoBoard
  Square = Struct.new(:item, :x, :y)

  attr_reader :id

  def initialize(board_data, id)
    @id = id
    @board_data = board_data
    @item_hash = {}
    board_data.each_with_index do |line, x|
      line.split(" ").map(&:to_i).each_with_index {|item, y| @item_hash[item] = Square.new(item, x, y)}
    end
    @marked_items = []
  end

  def mark(number)
    marking_square = @item_hash.fetch(number, nil)
    @marked_items << marking_square unless marking_square.nil?
  end

  def marked_numbers
    @marked_items.map(&:item)
  end

  def unmarked_numbers
    @item_hash.keys - @marked_items.map(&:item)
  end

  def won?
    winning_by(:x) || winning_by(:y)
  end

  private

  def winning_by(x_or_y)
    @marked_items.group_by(&x_or_y).transform_values(&:size).any? {|x_or_y, val| val >= 5 }
  end

end


class BingoGame
  attr_reader :board, :first_winning_number, :first_winning_turn, :final_score

  def initialize(board)
    @board = board
    @first_winning_number = nil
    @first_winning_turn = nil
  end

  def play(draws)
    draws.each_with_index do |number, turn|
      @board.mark(number)
      if @board.won?
        @first_winning_number = number
        @first_winning_turn = turn
        @final_score = board.unmarked_numbers.sum * number
        break
      end
    end
  end

end

class SquidCheater
  attr_reader :first_winning_board, :first_winning_board_score

  def initialize(game_file)
    @parser = GameParser.new
    @parser.parse(game_file)
  end

  def simulate
    winning_board_data = @parser.boards.map.with_index do |board, index|
      game = BingoGame.new(BingoBoard.new(board, index + 1))
      game.play(@parser.random_draws.split(',').map(&:to_i))
      unless game.first_winning_turn.nil?
        [game.board, game.first_winning_turn, game.final_score]
      else
        nil
      end
    end.compact.min_by {|board, turn, score| turn }

    @first_winning_board = winning_board_data[0]
    @first_winning_board_score = winning_board_data[2]
  end
end

class SquidSupporter
  attr_reader :last_winning_board, :last_winning_board_score

  def initialize(game_file)
    @parser = GameParser.new
    @parser.parse(game_file)
  end

  def simulate
    winning_board_data = @parser.boards.map.with_index do |board, index|
      game = BingoGame.new(BingoBoard.new(board, index + 1))
      game.play(@parser.random_draws.split(',').map(&:to_i))
      unless game.first_winning_turn.nil?
        [game.board, game.first_winning_turn, game.final_score]
      else
        nil
      end
    end.compact.max_by {|board, turn, score| turn }

    @last_winning_board = winning_board_data[0]
    @last_winning_board_score = winning_board_data[2]
  end
end

if __FILE__ == $PROGRAM_NAME
  cheater = SquidCheater.new('bingo_squid_input.txt')
  cheater.simulate

  puts "The final score of the winning board is: #{cheater.first_winning_board_score}"

  supporter = SquidSupporter.new('bingo_squid_input.txt')
  supporter.simulate

  puts "The final score of the winning board is: #{supporter.last_winning_board_score}"
end
