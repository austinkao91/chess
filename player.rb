require_relative 'board'
require_relative 'display'

class Player
  attr_reader :name, :color
  def initialize(name,color)
    @color = color
    @name = name
  end

  def get_display(display)
    @display = display
  end

  def take_turn
    confirm = false
    until confirm
      confirm = selection
    end
    player_prompt
  end

  def selection
    end_pos = nil
    while end_pos.nil?
      start_pos = make_first_selection
      show_move_options(start_pos)
      end_pos = make_second_selection
    end
    @display.grid.make_move(start_pos, end_pos, self.color)
    @display.move_positions = []
  end

  def player_prompt
    @display.render
    puts "Use WASD keys to move around the board"
    puts "It is #{self.color} to move! #{self.name} "
    puts "#{self.name} is in check!" if @display.grid.check?
    puts "#{self.name} is in check mate!" if @display.grid.check_mate?
  end

  def make_first_selection
    input = nil
    while !input.is_a?(Array) || !@display.grid[input].occupied?
      player_prompt
      puts "Making first selection"
      input = @display.get_input
    end
    puts "First selection made!"
    input
  end

  def show_move_options(start_pos)
    @display.move_positions = @display.grid[start_pos].move
    player_prompt
  end


  def make_second_selection
    input = nil
    while !input.is_a?(Array) || !@display.move_positions.include?(input)
      player_prompt
      puts "Making second selection"
      input = @display.get_input
      return escape_selection if input == "\e" || (input.is_a?(Array) && !@display.move_positions.include?(input))
    end
    puts "Second selection made!"
    input
  end

  def escape_selection
    @display.move_positions = []
    nil
  end



end
