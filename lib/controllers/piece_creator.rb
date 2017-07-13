module ChimaChess

  class PieceCreator
    PIECE_CLASSES={
      Pawn: 'ChimaChess::Pawn',
      Rook: 'ChimaChess::Rook',
      Knight: 'ChimaChess::Knight',
      Bishop: 'ChimaChess::Bishop',
      King: 'ChimaChess::King',
      Queen: 'ChimaChess::Queen'
    }

    def self.create_piece(piece_type:,color:,first_location:)
      Object.const_get(PIECE_CLASSES[piece_type]).new(color: color,first_location: first_location)
    end

  end
end
