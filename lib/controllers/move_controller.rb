module ChimaChess
  class PieceMover
    def self.move_piece(src,destination,board)
      piece = board.tile(src).piece
      clear(destination,board)
      board.tile(destination).piece = piece
      clear(src,board)
      piece.has_moved = true
    end
    def self.clear(tile_loc,board)
      board.tile(tile_loc).clear_piece
    end
  end

  class PawnMoveController < RegularMoveController

    def self.process(message,state)
      src_loc = find_piece_loc(message,state)

      if message.destination == state.enpassant_tile
        kill_enpassant(state)
        state.set_enpassant_tile(nil)
      elsif can_set_enpassant?(src,message.destination,state)
        set_enpassant(src,message.destination,state)
      else
        state.set_enpassant_tile(nil)
      end

      move_piece(src_loc,message.destination,state)
      king_check(state)
    end

    def self.kill_enpassant(state)
      state.tile(state.enpassant_victim).clear_piece
    end

    def self.can_set_enpassant?(src,destination,state)
      (destination[1] == "4") || (destination[1] == "5") && !state.piece(src).has_moved
    end

    def self.set_enpassant(src,destination,state)
      enpassant_rank = (destination[1].to_i + src[1].to_i)/2
      enpassant_file =  destination[0]
      enpassant_tile = "#{enpassant_file}#{enpassant_rank}"

      state.set_enpassant_tile(enpassant_tile)
      state.set_enpassant_victim(destination)
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
