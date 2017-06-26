module ChimaChess
  class PieceMover
    def self.move_piece(src,destination,board)
      piece = board.tile(src).piece
      clear(destination,board)
      board.tile(destination).piece = piece
      clear(src,board)
    end
    def self.clear(tile_loc,board)
      board.tile(tile_loc).clear_piece
    end
  end

  class PawnMoveController
    
  end

  class RegularMoveController
    def self.process(message,state)
      if message.piece_type == :Pawn
        process_pawn_move(message,state)
      else
        process_regular_move(message,state)
      end
    end
    def self.process_pawn_move(message,state)
      ChimaChess::PawnMoveController.process(message,state)
    end
    def self.process_regular_move(message,state)
      find_piece
      move_piece
      king_check
    end
  end

  class CastleMoveController
    def self.process(message,state)
      castle_positions = check_castle(message,state)
      move_castle_pieces(castle_positions,state)
    end
    def check_castle(message,state)
      ChimaChess::CastleCheck.check(
        side: message.castle_side,
        color: state.turn_to_play,
        board: state
        )
    end
    def move_castle_pieces(castle_positions,state)
      move_piece(castle_positions[:king_position],castle_positions[:king_destination],state)
      move_piece(castle_positions[:rook_position],castle_positions[:rook_destination],state)
    end
    def move_piece(src,destination,board)
      ChimaChess::PieceMover.move_piece(src,destination,board)
    end
  end

  class MoveController
    def self.process(message:, state:)
      send("process_#{message.move_class}",message,state)
    end
    def self.process_regular_move(message,state)
      ChimaChess::RegularMoveController.process(message,state)
    end
    def self.process_castle_move(message,state)
      ChimaChess::CastleMoveController.process(message,state)
      state.set_enpassant_tile(nil)
    end
  end
end
