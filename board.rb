require_relative 'piece'
require 'byebug'

class Board
  attr_accessor :grid
  ROYAL = [:R, :N, :B, :Q, :K, :B, :N, :R]

  def initialize(setup = true, board = nil)
    if setup
      @grid = Array.new(8) {Array.new(8)}
      set_pieces
    else
      @grid = board
    end
  end

  def set_pieces
    set_pawns(:white)
    set_royals(:white)
    set_pawns(:black)
    set_royals(:black)
    fill_empty
  end

  def fill_empty
    @grid.each_with_index do |row, row_idx|
      row.map!.with_index do |tile, col_idx|
        tile ||= NullPiece.new
      end
    end
  end

  def set_pawns(color)
    row_idx = ((color == :white) ? 1 : 6)
    @grid[row_idx].map!.with_index do |tile,index|
      tile = Pawn.new(color, [row_idx,index], self)
    end
  end

  def set_royals(color)
    row_idx = ((color == :white) ? 0 : 7)
    royal_row = []
    ROYAL.each_with_index do |royal, idx|
      royal_row << royal_piece(royal,color,[row_idx,idx ])
    end
    @grid[row_idx] = royal_row
  end

  def royal_piece(royal,color, pos)
    case royal
    when :R
      Rook.new(color,pos,self)
    when :B
      Bishop.new(color,pos,self)
    when :N
      Knight.new(color,pos,self)
    when :Q
      Queen.new(color,pos,self)
    when :K
      King.new(color,pos,self)
    end
  end

  def [](pos)
    row,col = pos
    @grid[row][col]
  end

  def []=(pos,val)
    row,col = pos
    @grid[row][col] = val
  end

  def set_move(start,final)
    self[start].get_board(self)
    if self[start].get_move.include?(final)
      self[start], self[final] = self[final], self[start]
    end

  end

  def in_bounds?(pos)
    row,col = pos
    row >= 0 && row <= 7 && col >= 0 && col <=7
  end

  def check_mate?(color)
    @grid.flatten.none? do |piece|
      (piece.color == color) ? !piece.move.empty? : false
    end
  end

  def in_check?(color)
    king_pos = find_king(color)
    @grid.flatten.any? {|piece| piece.color != color && piece.get_valid_moves.include?(king_pos)}
  end

  def find_king(color)
    @grid.flatten.find { |piece| piece.class == King && piece.color == color }.position
  end

  def valid_move(pos_array)

  end

  def make_move(start_pos, end_pos)
    if self[start_pos].move.include?(end_pos)
      if self[end_pos].occupied?
        self[end_pos] = NullPiece.new
      end
      self[start_pos].position = end_pos
      self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
      true
    end
    return false
  end

  def make_move!(start_pos, end_pos)
    if self[end_pos].occupied?
      self[end_pos] = NullPiece.new
    end
    self[start_pos].position = end_pos
    self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
  end

  def dup
    new_grid = @grid.map { |row| row.dup }
    new_board = Board.new(false, new_grid)

    new_board.grid.map! do |row|
      row.map! do |piece|
        new_piece = piece.class.new(piece.color, piece.position, new_board)
        new_piece
      end
    end

    new_board
  end
end
