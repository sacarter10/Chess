require 'yaml'
require_relative 'piece'
require_relative 'board'
require_relative 'player'

class Chess

  def run
    puts "Welcome to Chess!"

    board = Board.new()
    player1 = Player.new(:white, board)
    player2 = Player.new(:black, board)
    board.add_players([player1, player2])

    current_player = player1

    while current_player.game_over == "continue"
      if player1.checkmate? || player2.checkmate?
        puts "Checkmate!"
      end

      if player1.check? || player2.check?
        puts "Check"
      end

      get_user_move

      current_player = current_player == player1 ? player2 : player1
    end

    if current_player.game_over == "checkmate"
      puts "#{current_player.color} is in checkmate. Game over."
    else
      "#{current_player.color} has no legal moves. The game is a draw."
    end
  end

end



my_board = Board.new()
my_board.add_players(Player.new(:white, my_board), Player.new(:black, my_board))
my_board.move_piece([7, 4], [6, 3])

