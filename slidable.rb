require_relative "piece"

class Slidable < Piece

  def get_move
    validated_moves = []
    puts VECTORS
    VECTORS.each do |vec|
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
