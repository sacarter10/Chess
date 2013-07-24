class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def  brown;         "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\0330m"  end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end


class Piece
  attr_accessor :position
  attr_reader :player

  def initialize(board, player, position)
    @board = board
    @player = player
    @player.add_piece(self)
    @position = position
  end

  def kill
    @player.remove_piece(self)
  end

  def poss_moves
  end

  def non_check_moves(possible_moves)
    non_suicidal = possible_moves.select do |move|
      new_board = @board.deep_dup

      new_board.hyp_move_piece(@position, move)
      our_player = @player.color == new_board.player1.color ? new_board.player1 : new_board.player2
      opponent = our_player == new_board.player1 ? new_board.player2 : new_board.player1

      !our_player.check?
    end
    non_suicidal
  end

  def to_s
    @player.color == :white ? "#{@string_rep}".gray : "#{@string_rep}".blue
  end

  # def valid_move?(end_position)
  #   non_check_moves.include?(end_position)
  # end
end

# Should this be a module called Slideable???
class SlidingPiece < Piece
  def initialize(board, player, positions)
    super(board, player, positions)
  end

  def poss_moves
    moves = []

    @directions.each do |drow, dcol|
      new_row = @position.first + drow
      new_col = @position.last + dcol

      next unless Board.on_board?([new_row, new_col])

      # the loop will stop at the last square that's still on the board, on top of an enemy piece
      # or on top of a friendly piece
      while @board[new_row][new_col].nil? && Board.on_board?([new_row + drow, new_col + dcol])
        moves << [new_row, new_col]
        new_row += drow
        new_col += dcol
      end

      if @board[new_row][new_col].nil? || @board[new_row][new_col].player != @player
        moves << [new_row, new_col]
      end
    end

    moves
  end
end

class SteppingPiece < Piece

end

class Pawn < Piece
  def initialize(board, player, position)
    super(board, player, position)
    @original_position = position
    @orientation = (@original_position.first == 1) ? :top : :bottom
    @string_rep = "p"
  end

  def poss_moves
    orow, ocol = @original_position
    row, col = @position
    moves = []

    drow = 1 if @orientation == :top
    drow = -1 if @orientation == :bottom

    moves << [row + drow, col] if Board.on_board?([row + drow, col]) && @board[row + drow][col].nil?

    moves << [row + 2 * drow, col] if orow == row && @board[row + 2 * drow][col].nil? && @board[row + drow][col].nil?

    [1, -1].each do |dcol|
      if Board.on_board?([row + drow, col + dcol])
        unless @board[row + drow][col + dcol].nil? || @board[row + drow][col + dcol].player == player
          moves << [row + drow, col + dcol]
        end
      end
    end

    moves
  end

end

class Rook < SlidingPiece
  def initialize(board, player, position)
    @directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    @string_rep = "R"
    super(board, player, position)
  end
end

class Bishop < SlidingPiece
  def initialize(board, player, position)
    @directions = [[-1, -1], [1, 1], [1, -1], [-1, 1]]
    super(board, player, position)
    @string_rep = "B"
  end
end

class Knight < SteppingPiece
  def initialize(board, player, position)
    super(board, player, position)
    @string_rep = "N"
  end

  def poss_moves
    row, col = @position
    moves = []

    [-2, -1, 1, 2].each do |drow|
      [-2, -1, 1, 2].each do |dcol|
        next if drow.abs == dcol.abs
        moves << [row + drow, col + dcol]
      end
    end

    moves.select! {|move| Board.on_board?(move)}
    moves.select! do |move|
      move_row, move_col = move
      @board[move_row][move_col].nil? || @board[move_row][move_col].player != player
    end

    moves
  end
end

class Queen < SlidingPiece
  def initialize(board, player, position)
    @directions = [[-1, -1], [1, 1], [1, -1], [-1, 1], [-1, 0], [1, 0], [0, -1], [0, 1]]
    super(board, player, position)
    @string_rep = "Q"
  end
end

class King < SteppingPiece
  def initialize(board, player, position)
    super(board, player, position)
    @string_rep = "K"
  end

  def poss_moves
    row, col = @position
    moves = []

    [-1, 0, 1].each do |drow|
      [-1, 0, 1].each do |dcol|
        next if drow == 0 && dcol == 0
        moves << [row + drow, col + dcol]
      end
    end

    moves.select! {|move| Board.on_board?(move)}
    moves.select! do |move|
      move_row, move_col = move
      @board[move_row][move_col].nil? || @board[move_row][move_col].player != player
    end

    moves
  end
end