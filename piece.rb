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

  def non_check_moves
    non_suicidal = poss_moves.select do |move|
      new_board = @board.deep_dup

      new_board.hyp_move_piece(@position, move)
      our_player = @player.color == new_board.player1.color ? new_board.player1 : new_board.player2
      opponent = our_player == new_board.player1 ? new_board.player2 : new_board.player1

      !our_player.check?

      # opponents_moves = []
#
#       opponent.available_pieces.each do |piece|
#         opponents_moves += piece.poss_moves
#       end
#
#       our_king_position = nil
#
#       our_player.available_pieces.each do |piece|
#         if piece.is_a? King
#           our_king_position = piece.position
#         end
#       end
#
#       if opponents_moves.include? our_king_position
#         false
#       else
#         true
#       end
    end
    non_suicidal
  end

  def valid_move?(end_position)
    non_check_moves.include?(end_position)
  end
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
  end

  def poss_moves
    orow, ocol = @original_position
    row, col = @position
    moves = []

    drow = 1 if @orientation == :top
    drow = -1 if @orientation == :bottom

    moves << [row + drow, col] if @board[row + drow][col].nil?

    moves << [row + 2 * drow, col] if orow == row && @board[row + 2 * drow][col].nil? && @board[row + drow][col].nil?

    unless @board[row + drow][col + 1].nil? || @board[row + drow][col + 1].player == player
      moves << [row + drow, col + 1]
    end
    unless @board[row + drow][col - 1].nil? || @board[row + drow][col - 1].player == player
      moves << [row + drow, col - 1]
    end

    moves.select {|position| Board.on_board?(position)}
  end
end

class Rook < SlidingPiece
  def initialize(board, player, position)
    @directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    super(board, player, position)
  end
end

class Bishop < SlidingPiece
  def initialize(board, player, position)
    @directions = [[-1, -1], [1, 1], [1, -1], [-1, 1]]
    super(board, player, position)
  end
end

class Knight < SteppingPiece
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
  end
end

class King < SteppingPiece
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