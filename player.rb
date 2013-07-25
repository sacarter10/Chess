class Player
  attr_reader :color, :available_pieces, :board

  def initialize(color, board)
    @color = color
    @available_pieces = []
    @board = board
  end

  def add_piece(piece)
    @available_pieces << piece
  end

  def get_opponent
    @opponent ||= @color == @board.player1.color ? @board.player2 : @board.player1
  end

  def check?
    get_opponent
    opponents_moves = []

    @opponent.available_pieces.each do |piece|
      opponents_moves += piece.poss_moves
    end

    our_king_position = nil

    @available_pieces.each do |piece|
      if piece.is_a? King
        our_king_position = piece.position
      end
    end

    opponents_moves.include?(our_king_position)
  end

  def game_over
    #are there any legal moves? && self.check?
    if @available_pieces.all? { |piece| piece.non_check_moves(piece.poss_moves).empty? }
      check? ? "checkmate" : "draw"
    else
      "continue"
    end

  end

  def remove_piece(piece)
    @available_pieces.delete(piece)
  end
end