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
    system 'clear'
    puts "Use WASD keys to move around the board"
    row_idx = @grid.grid.length-1
    @grid.grid.reverse_each do |row|
      rows = row.map.with_index do |piece, col_idx|
        tile_color = color(row_idx, col_idx)
        piece.to_s.colorize(tile_color)
      end
      puts rows.join
      row_idx -= 1
    end
    puts "check!" if @grid.in_check?(:black)
    puts "check mate!" if @grid.check_mate?(:black)
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

  def take
    while true
      take_turn

    end
  end

  def take_turn
    start_pos = make_first_selection
    show_move_options(start_pos)
    end_pos = make_second_selection
    while end_pos.nil?
      start_pos = make_first_selection
      show_move_options(start_pos)
      end_pos = make_second_selection
    end
    puts "make move!"
    grid.make_move(start_pos,end_pos)
    @move_positions = []
    render
  end

  def make_first_selection
    render
    puts "Making first selection"
    input = get_input
    while !input.is_a?(Array) || !grid[input].occupied?
      render
      puts "Making first selection"
      input = get_input
    end
    puts "First selection made!"
    input
  end

  def show_move_options(start_pos)
    @move_positions = grid[start_pos].move
    render
  end

  def make_second_selection
    render
    puts "Making second selection"
    input = get_input
    return escape_selection if input == "\e"
    while !input.is_a?(Array) || !@move_positions.include?(input)
      render
      puts "Making second selection"
      input = get_input
      return escape_selection if input == "\e"
    end
    puts "Second selection made!"
    input
  end

  def escape_selection
    @move_positions = []
    nil
  end
end

grid = Board.new
display = Display.new(grid)
display.take

#propt user for piece selection
#user picks piece
#display possible moves and prompt user for second position




# while(true)
#   system "clear"
#   display.render
#   pos = display.get_input unless display.selected
#   unless pos.nil?
#     grid[pos].get_board(grid)
#     display.move_positions = grid[pos].get_valid_moves if display.move_positions.empty?
#   end
#   display.move_positions = [] unless display.selected
#   if display.selected
#     system "clear"
#     display.render
#     pos2 = display.get_input
#   end
#   if display.selected && !pos2.nil?
#     grid.make_move(pos,pos2)
#     display.selected = false
#   end
# end
