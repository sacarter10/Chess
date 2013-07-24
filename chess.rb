require 'yaml'
require_relative 'piece'
require_relative 'board'
require_relative 'player'

class ChessGame

  def run
    puts "Welcome to Chess!"

    board = Board.new()
    player1 = Player.new(:black, board)
    player2 = Player.new(:white, board)
    board.add_players(player1, player2)

    current_player = player2

    while current_player.game_over == "continue"
      if current_player.check?
        puts "#{current_player.color} is in check."
      end

      puts "#{current_player.color}'s move."

      user_move = get_user_move

      until board.move_piece(user_move[0], user_move[1])
        user_move = get_user_move
      end


      current_player = current_player == player1 ? player2 : player1
    end

    if current_player.game_over == "checkmate"
      puts "#{current_player.color} is in checkmate. Game over."
    else
      "#{current_player.color} has no legal moves. The game is a draw."
    end
  end

  def get_user_move
    puts "Enter your move in the format 'starting postion, ending position'."
    move = gets.chomp.split(", ")

    #validate user input

    start_pos = translate_position(move.first)
    end_pos = translate_position(move.last)

    [start_pos, end_pos]
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
# my_board.add_players(Player.new(:white, my_board), Player.new(:black, my_board))
# my_board.move_piece([7, 4], [6, 3])

