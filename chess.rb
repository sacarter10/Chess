require 'yaml'
require_relative 'piece'
require_relative 'board'
require_relative 'player'
require 'debugger'

class ChessGame

  def run
    puts "Welcome to Chess!"

    @board = Board.new()
    @player1 = Player.new(:black, @board)
    @player2 = Player.new(:white, @board)
    @board.add_players(@player1, @player2)

    @board.build_board

    @current_player = @player2
    @board.print_board

    while @current_player.game_over == "continue"


      if @current_player.check?
        puts "#{@current_player.color.to_s.capitalize} is in check."
      end

      puts "#{@current_player.color.to_s.capitalize}'s move."

      user_move = get_user_move

      begin
        @board.can_move(user_move[0], user_move[1])
      rescue ArgumentError => message
        puts message
        user_move = get_user_move
        retry
      end

      @board.move_piece(user_move[0], user_move[1])

      @board.print_board
      @current_player = @current_player == @player1 ? @player2 : @player1
    end

    if @current_player.game_over == "checkmate"
      puts "#{@current_player.color.to_s.capitalize} is in checkmate. Game over."
    else
      puts "#{@current_player.color.to_s.capitalize} has no legal moves. The game is a draw."
    end
  end

  def get_user_move
    while true

      puts "Enter your move in the format 'starting postion, ending position'."
      move = gets.chomp

      unless move =~ /[A-Za-z]\d,\s[A-Za-z]\d+/
        puts "Your formatting is wrong."
        next
      end

      move = move.split(", ")

      start_pos = translate_position(move.first)
      end_pos = translate_position(move.last)

      unless Board.on_board?(start_pos)  && Board.on_board?(end_pos)
        puts "That square is not on the board"
        next
      end

      unless !@board[start_pos.first][start_pos.last].nil? && @board[start_pos.first][start_pos.last].player == @current_player
        puts "You can only move your own pieces."
        next
      end

      return [start_pos, end_pos]
    end
  end

  #i.e., user enters A2 => board position [6, 0]
  def translate_position(pos)
    col = pos[0].upcase.ord - 65
    row = 8 - pos[1].to_i

    [row, col]
  end

end



my_game = ChessGame.new()
my_game.run()

