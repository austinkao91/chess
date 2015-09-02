require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game


  def initialize(player1,player2)
    @board = Board.new
    @display = Display.new(@board)
    @players = [player1,player2]
  end

  def play
    start_game
    until over?
      render
      take_turn
      rotate_players
    end
    game_over_message
  end


  attr_reader :board, :display
  def rotate_players
    @players.rotate!
  end

  def over?
    @board.check_mate?
  end

  def start_game
    "Welcome! White player #{@players[0].name} starts!"
    @players.each {|player| player.get_display(@display)}
  end

  def game_over_message
    puts "#{@players[1].name} has put #{@players[0].name} in checkmate!"
    puts "#{@players[1].color} has won!"
  end

  def render
    system "clear"
    @display.render
  end



  def take_turn
    @players[0].take_turn
  end

end

a = Player.new("bob", :white)
b = Player.new("marley", :black)
game = Game.new(a,b)
game.play
