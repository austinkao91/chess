
class Piece
  attr_reader :board, :color, :position
  attr_accessor :position
  def initialize(color,pos,board)
    @color = color
    @position = pos
    @board = board
  end

  def get_board(board)
    @board = board
  end

  def valid_move?(pos)
    @board.in_bounds?(pos) && !@board[pos].occupied?
  end

  def capturable?(pos)
    @board.in_bounds?(pos) && (!@board[pos].occupied? || @board[pos].color != self.color)
  end

  def to_s
    " P "
  end

  def occupied?
    true
  end

  def move
    moves = get_valid_moves
    moves.reject do |possible_position|
      test_board =  @board.dup
      test_board.make_move!(@position, possible_position)
      test_board.in_check?(self.color)
    end
  end
end

class Slidable < Piece
  HOR_VECTORS = [[1,0],[-1,0], [0,1], [0,-1]]
  DIAG_VECTORS = [[1,1],[-1,-1], [-1,1], [1,-1]]
  def get_valid_moves
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
      validated_moves << pos if capturable?(pos)
    end
    validated_moves
  end
end

class Steppable < Piece

  def get_valid_moves
    validated_moves = []
    @vectors.each do |vec|
      dx,dy = vec
      pos = [position[0] + dx, position[1] + dy]
      validated_moves << pos if capturable?(pos)
    end
    validated_moves
  end
end

class NullPiece < Piece
  def initialize(color = nil, pos = nil, board = nil)
  end
  def to_s
    "   "
  end

  def get_board(board)
  end
  def get_valid_moves
    []
  end
  def occupied?
    false
  end
end

class Knight < Steppable
  def initialize(color,pos,board)
    super(color,pos,board)
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
  def initialize(color,pos,board)
    super(color,pos, board)
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
  def initialize(color,pos,board)
    super(color,pos,board)
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
  def initialize(color,pos,board)
    super(color,pos,board)
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
  def initialize(color,pos,board)
    super(color,pos,board)
    @moved = false
  end

  def get_valid_moves
    delta =  color == :white ? 1 : -1
    pos = [position[0] + delta, position[1]]
    capl = [position[0]+ delta, position[1] + delta]
    capr = [position[0]+ delta, position[1] - delta]
    validated_moves = []
    validated_moves << pos if valid_move?(pos)
    validated_moves << capl if capturable?(capl)
    validated_moves << capr if capturable?(capr)
    unless @moved || !validated_moves.include?(pos)
      pos2 = [pos[0] + delta, pos[1]]
      validated_moves << pos2 if valid_move?(pos2)
    end
    validated_moves
  end

  def capturable?(check_pos)
    if check_pos[1] == (position[1] + 1) || check_pos[1] == (position[1]- 1 )
      if @board.in_bounds?(check_pos) && @board[check_pos].occupied? && (@board[check_pos].color != self.color)
        return true
      end
    end
    false
  end

  def valid_move?(check_pos)
    @board.in_bounds?(check_pos) && !@board[check_pos].occupied? && check_pos[1] == position[1]
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
  def initialize(color,pos,board)
    super(color,pos,board)
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
