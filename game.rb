require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game


  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = [player1,player2]
    self.play
  end

  def play
    start_game_message
    until over?
      render
      make_move(prompt_move)
      rotate_players
    end
    game_over_message
  end

  private
  attr_reader :board, :display
  def rotate_players
    @players.rotate!
  end

  def over?
    @board.checkmate?
  end

  def start_game_message
    "Welcome! White player #{@players[0].name} starts!"
  end

  def game_over_message
    puts "#{@players[1]} has put #{@players[0]} in checkmate!"
    puts "#{@players[1].color} has won!"
  end

  def render
    system "clear"
    @display.render
  end

  def prompt_move
    @player[0].get_move
  end

  def make_move(start, end_pos)
    @board.make_move!(start,end_pos)
  end
end

game = Game.new
