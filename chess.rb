class Chess

  def run
    puts "Welcome to Chess!"

    player1 = Player.new(:white)
    player2 = Player.new(:black)
    board = Board.new()

    current_player = player1

    until false
      if player1.checkmate? || player2.checkmate?
        puts "Checkmate!"
      end

      if player1.check? || player2.check?
        puts "Check"
      end

      get_user_move

      current_player = current_player == player1 ? player2 : player1
  end

end

class Player
  attr_reader :color, :available_pieces

  def initialize(color)
    @color = color
    @available_pieces = []
  end

  def add_piece(piece)
    @available_pieces << piece
  end

  def check?
    #do other player's possible moves include my king's position?
  end

  def checkmate?
    #are there any legal moves? && self.check?
  end

  def remove_piece(piece)
    @available_pieces.delete(piece)
  end
end

class Board
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    build_board
  end

  def build_board
    @grid = Array.new(8) {Array.new(8)}

    [1, 6].each do |row|
      (0..7).each do |col|
      @grid[row][col] = Pawn.new(self, player1, [row, col]) if row == 1
      @grid[row][col] = Pawn.new(self, player2, [row, col]) if row == 6
    end

    @grid[0][0] = Rook.new(self, player1, [0, 0])
    @grid[0][1] = Knight.new(self, player1, [0, 1])
    @grid[0][2] = Bishop.new(self, player1, [0, 2])
    @grid[0][3] = Queen.new(self, player1, [0, 3])
    @grid[0][4] = King.new(self, player1, [0, 4])
    @grid[0][5] = Bishop.new(self, player1, [0, 5])
    @grid[0][6] = Knight.new(self, player1, [0, 6])
    @grid[0][7] = Rook.new(self, player1, [0, 7])

    @grid[7][0] = Rook.new(self, player2, [7, 0])
    @grid[7][1] = Knight.new(self, player2, [7, 1])
    @grid[7][2] = Bishop.new(self, player2, [7, 2])
    @grid[7][3] = Queen.new(self, player2, [7, 3])
    @grid[7][4] = King.new(self, player2, [7, 4])
    @grid[7][5] = Bishop.new(self, player2, [7, 5])
    @grid[7][6] = Knight.new(self, player2, [7, 6])
    @grid[7][7] = Rook.new(self, player2, [7, 7])
  end

  def move_piece(start_position, end_position)
    start_row, start_col = start_position
    end_row, end_col = end_position

    current_piece = @grid[start_row][start_col]

    if current_piece.valid_move?(end_position)
      unless @grid[end_row][end_col] == nil
        old_piece = @grid[end_row][end_col]
        old_piece.kill
      end

      @grid[end_row][end_col] = @grid[start_row][start_col]
      @grid[start_row][start_col] = nil
    else
      puts "That is an invalid move."
    end #if
  end

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

  def non_check_moves
  end

  def valid_move?
  end
end

class Pawn < Piece
  def initialize(board, player, position)
    super(board, player, postion)
    @original_position = position
    @orientation = (@original_position.first == 1) ? :top : :bottom
  end

  def poss_moves

  end
end

class Rook < Piece
end

class Bishop < Piece
end

class Knight < Piece
end

class Queen < Piece
end

class King < Piece
end

