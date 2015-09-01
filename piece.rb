
class Piece
  attr_reader :board, :color, :position
  def initialize(color,pos)
    @color = color
    @position = pos
  end

  def get_board(board)
    @board = board

  end


  def valid_move?(pos)
    @board.in_bounds?(pos) && !@board[pos].occupied?
  end

  def to_s
    " P "
  end

  def occupied?
    true
  end
end

class Slidable < Piece
  HOR_VECTORS = [[1,0],[-1,0], [0,1], [0,-1]]
  DIAG_VECTORS = [[1,1],[-1,-1], [-1,1], [1,-1]]
  def get_move
    vectors = []
    vectors += HOR_VECTORS if @horizontal
    vectors += DIAG_VECTORS if @diagonal
    validated_moves = []
    vectors.each do |vec|
      dx, dy = vec
      pos = [position[0] + dx, position[1] + dy]
      while(valid_move?(pos))
        validated_moves << pos
        pos = [pos[0] + dx, pos[1] + dy]
      end
    end
    validated_moves
  end
end

class Steppable < Piece
  def get_move
    validated_moves = []
    @vectors.each do |vec|
      dx,dy = vec
      pos = [position[0] + dx, position[1] + dy]
      validated_moves << pos if valid_move?(pos)
    end
    validated_moves
  end
end

class NullPiece < Piece
  def initialize
  end
  def to_s
    "   "
  end
  def get_move(pos)
    []
  end
  def occupied?
    false
  end
end

class Knight < Steppable
  def initialize(color,pos)
    super(color,pos)
    @vectors = [[-2,-1], [-2,1], [2,-1], [2,1], [-1,-2], [-1,2], [1,-2], [1,2]]
  end
  def to_s
    case color
    when :white
      " " + "\u2658".encode("utf-8") + " "
    when :black
      " "  + "\u265E".encode("utf-8") + " "
    end
  end
end

class Rook < Slidable
  def initialize(color,pos)
    super(color,pos)
    @horizontal = true
    @diagonal = false
  end
  def to_s
    case color
    when :white
      " " + "\u2656".encode("utf-8") + " "
    when :black
      " "  + "\u265C".encode("utf-8") + " "
    end
  end
end


class Queen < Slidable
  def initialize(color,pos)
    super(color,pos)
    @horizontal = true
    @diagonal = true
  end
  def to_s
    case color
    when :white
      " " + "\u2655".encode("utf-8") + " "
    when :black
      " "  + "\u265B".encode("utf-8") + " "
    end
  end
end

class Bishop < Slidable
  def initialize(color,pos)
    super(color,pos)
    @horizontal = false
    @diagonal = true
  end
  def to_s
    case color
    when :white
      " " + "\u2657".encode("utf-8") + " "
    when :black
      " "  + "\u265D".encode("utf-8") + " "
    end
  end
end

class Pawn < Piece
  def initialize(color,pos)
    super(color,pos)
    @moved = false
  end
  def get_move
    if color == :white
      delta = 1
    elsif color == :black
      delta = -1
    end
    pos = [position[0] + delta, position[1]]
    validated_moves = []
    validated_moves << pos if valid_move?(pos)
    unless @moved
      pos2 = [pos[0] + delta, pos[1]]
      validated_moves << pos2 if valid_move?(pos2)
    end
    validated_moves
  end
  def to_s
    case color
    when :white
      " " + "\u2659".encode("utf-8") + " "
    when :black
      " "  + "\u265F".encode("utf-8") + " "
    end
  end
end

class King < Steppable
  def initialize(color,pos)
    super(color,pos)
    @vectors = [[-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1]]
  end
  def to_s
    case color
    when :white
      " " + "\u2654".encode("utf-8") + " "
    when :black
      " "  + "\u265A".encode("utf-8") + " "
    end
  end
end
