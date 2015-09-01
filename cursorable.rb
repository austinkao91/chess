require "io/console"

module Cursorable
  KEYMAP = {
    " " => :space,
    "h" => :left,
    "j" => :down,
    "k" => :up,
    "l" => :right,
    "w" => :left,
    "a" => :down,
    "s" => :up,
    "d" => :right,
    "\t" => :tab,
    "\r" => :return,
    "\n" => :newline,
    "\e" => :escape,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left,
    "\177" => :backspace,
    "\004" => :delete,
    "\u0003" => :ctrl_c,
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [1, 0],
    down: [-1, 0]
  }

  def get_input
    key = KEYMAP[readchar]
    position_map(key)
  end

  def readchar
    STDIN.echo = false
    STDIN.raw!
    input = STDIN.getc
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def position_map(key)
    case key
    when :left, :right, :up , :down
      update(MOVES[key])
      nil
    when :return, :space
      @selected_square = @cursor_position if @selected == false
      @selected = true
      @cursor_position
    when :ctrl_c
      exit 0
    when :escape
      @selected = false
      @selected_square = []
      nil
    else
      puts key
    end
  end

  def update(pos)
    dx, dy = pos
    curs_x, curs_y = @cursor_position
    new_pos = [curs_x + dx, curs_y + dy]
    @cursor_position = new_pos if @grid.in_bounds?(new_pos)
  end

end
