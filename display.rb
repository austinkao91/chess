require "colorize"
require_relative "piece"
require_relative "cursorable"
require_relative 'board'

class Display
  include Cursorable
  attr_accessor :selected, :move_positions
  attr_reader :grid

  def initialize(grid)
    @grid = grid
    @cursor_position = [0,0]
    @move_positions = []
    @selected = false
    @selected_square = nil
  end

  def render
    puts "Use WASD keys to move around the board"
    row_idx = @grid.length-1
    @grid.grid.reverse_each do |row|
      rows = row.map.with_index do |piece, col_idx|
        tile_color = color(row_idx, col_idx)
        piece.to_s.colorize(tile_color)
      end
      puts rows.join
      row_idx -= 1
    end
    nil
  end

  def color(row,col)
    if @selected_square == [row,col]
      bg = :magenta
    elsif [row,col] == @cursor_position
      bg = :light_green
    elsif @move_positions.include?([row,col])
      bg = :yellow
    elsif((row+col).odd?)
      bg = :light_red
    else
      bg = :light_blue
    end
    { background: bg, color: @grid[[row,col]].color }
  end


end

grid = Board.new
display = Display.new(grid)
while(true)
  system "clear"
  display.render
  pos = display.get_input
  unless pos.nil?
    grid[pos].get_board(grid)
    display.move_positions = grid[pos].get_move if display.move_positions.empty?
  end
  p display.move_positions
  display.move_positions = [] unless display.selected
end
