class Board
  attr_reader :player1, :player2

  def initialize()
  end

  def add_players(player1, player2)
    @player1 = player1
    @player2 = player2
    build_board
  end

  def [](row)
    @grid[row]
  end

  def build_board
    @grid = Array.new(8) {Array.new(8)}

    [1, 6].each do |row|
      (0..7).each do |col|
        next if col == 3
        @grid[row][col] = Pawn.new(self, @player1, [row, col]) if row == 1
        @grid[row][col] = Pawn.new(self, @player2, [row, col]) if row == 6
      end
    end
    @grid[0][0] = Rook.new(self, @player1, [0, 0])
    @grid[0][1] = Knight.new(self, @player1, [0, 1])
    @grid[0][2] = Bishop.new(self, @player1, [0, 2])
    @grid[0][3] = Queen.new(self, @player1, [0, 3])
    @grid[0][4] = King.new(self, @player1, [0, 4])
    @grid[0][5] = Bishop.new(self, @player1, [0, 5])
    @grid[0][6] = Knight.new(self, @player1, [0, 6])
    @grid[0][7] = Rook.new(self, @player1, [0, 7])

    @grid[7][0] = Rook.new(self, @player2, [7, 0])
    @grid[7][1] = Knight.new(self, @player2, [7, 1])
    @grid[7][2] = Bishop.new(self, @player2, [7, 2])
    @grid[7][3] = Queen.new(self, @player2, [7, 3])
    @grid[7][4] = King.new(self, @player2, [7, 4])
    @grid[7][5] = Bishop.new(self, @player2, [7, 5])
    @grid[7][6] = Knight.new(self, @player2, [7, 6])
    @grid[7][7] = Rook.new(self, @player2, [7, 7])
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
      @grid[end_row][end_col].position = [end_row, end_col]
      @grid[start_row][start_col] = nil
      return true
    else
      return false
    end
  end

  #this allows us to make moves that put us in check. used in non_check_moves method
  def hyp_move_piece(start_position, end_position)
    start_row, start_col = start_position
    end_row, end_col = end_position

    current_piece = @grid[start_row][start_col]

    if current_piece.poss_moves.include?(end_position)
      unless @grid[end_row][end_col] == nil
        old_piece = @grid[end_row][end_col]
        old_piece.kill
      end

      @grid[end_row][end_col] = @grid[start_row][start_col]
      @grid[end_row][end_col].position = [end_row, end_col]
      @grid[start_row][start_col] = nil
    else
      puts "That is an invalid move."
    end #if
  end

  def self.on_board?(position)
    row, col = position
    row >= 0 && row < 8 && col >= 0 && col < 8
  end

  def deep_dup
    YAML.load(self.to_yaml)
  end

end

#TO_DO add a simpler/custom dup method for Board