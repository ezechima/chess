module ChimaChess
require './lib/controllers/pawn_move_controller.rb'
require './lib/controllers/find_piece.rb'
require './lib/controllers/castle_check.rb'
  class PieceMover
    def self.move_piece(src,destination,board)
      piece = board.tile(src).piece
      set_piece(piece,destination,board)
      clear(src,board)
    end
    def self.set_piece(piece,destination,board)
      clear(destination,board)
      board.tile(destination).piece = piece
      piece.has_moved = true
    end
    def self.clear(tile_loc,board)
      board.tile(tile_loc).clear_piece
    end
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
      src_loc = find_piece_loc(message,state)
      move_piece(src_loc,message.destination,state)
      king_check(state)
      state.set_enpassant_tile(nil)
    end
    def self.find_piece_loc(message,state)
      piece_hash = ChimaChess::FindPiece.find(
                      board: state,
                      color: state.turn_to_play,
                      type: message.piece_type,
                      destination_str: message.destination,
                      file: message.file,
                      rank: message.rank
                    )
      piece_hash.values[0].attacker_location
    end
    def self.king_check(state)
      ChimaChess::KingChecker.check(state)
    end
    def self.move_piece(src,destination,board)
      ChimaChess::PieceMover.move_piece(src,destination,board)
    end
  end

  class CastleMoveController
    def self.process(message,state)
      castle_positions = check_castle(message,state)
      move_castle_pieces(castle_positions,state)
    end
    def self.check_castle(message,state)
      ChimaChess::CastleCheck.check(
        side: message.castle_side,
        color: state.turn_to_play,
        board: state
        )
    end
    def self.move_castle_pieces(castle_positions,state)
      move_piece(castle_positions[:king_position],castle_positions[:king_destination],state)
      move_piece(castle_positions[:rook_position],castle_positions[:rook_destination],state)
    end
    def self.move_piece(src,destination,board)
      ChimaChess::PieceMover.move_piece(src,destination,board)
    end
  end

  class MoveController

    def self.process(message:, state:)
      send("process_#{message.move_class}",message,state)
      state
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
