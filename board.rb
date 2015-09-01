require_relative 'piece'

class Board
  attr_reader :grid, :length
  ROYAL = [:R, :N, :B, :Q, :K, :B, :N, :R]

  def initialize(row = 8, col = 8)
    @grid = Array.new(8) {Array.new(8){NullPiece.new()}}
    @length = row
    set_pieces
  end

  def set_pieces
    set_pawns(:white)
    set_royals(:white)
    set_pawns(:black)
    set_royals(:black)
  end

  def set_pawns(color)

    case color
    when :white
      @grid[1].map!.with_index do |tile,index|
        tile = Pawn.new(:white, [1,index])
      end
    when :black
      @grid[6].map!.with_index do |tile,index|
        tile = Pawn.new(:black, [6,index])
      end
    end
  end

  def set_royals(color)
    case color
    when :white
      white_royal = []
      ROYAL.each_with_index do |royal, idx|
        white_royal << royal_piece(royal,color,[0,idx ])
      end
      @grid[0] = white_royal
    when :black
      black_royal = []
      ROYAL.each_with_index do |royal, idx|
        black_royal << royal_piece(royal,color,[7,idx ])
      end
      @grid[7] = black_royal
    end
  end

  def royal_piece(royal,color, pos)
    case royal
    when :R
      Rook.new(color,pos)
    when :B
      Bishop.new(color,pos)
    when :N
      Knight.new(color,pos)
    when :Q
      Queen.new(color,pos)
    when :K
      King.new(color,pos)
    end
  end

  def [](pos)
    row,col = pos
    @grid[row][col]
  end

  def get_move(*pos)

  end

  def in_bounds?(pos)
    row,col = pos
    row >= 0 && row <= 7 && col >= 0 && col <=7
  end
end

board = Board.new
board.grid.each do |row|
  rows = row.map do |piece|
    piece.position
  end
  puts rows.join("")
end
