module ChimaChess
  require './lib/controllers/move_controller.rb'
  require './lib/controllers/find_piece.rb'
  class PawnMoveController

    def self.process(message,state)
      src_loc = find_piece_loc(message,state)
      destination = message.destination
      check_enpassant_conditions(src_loc,destination,state)
      move_piece(src_loc, destination,state)
      reduce_advance(destination,state)
      king_check(state)
      check_piece_promotion(destination,state)
    end
    def self.check_enpassant_conditions(src,destination,state)
      if destination == state.enpassant_tile
        kill_enpassant(state)
        state.set_enpassant_tile(nil)
      elsif can_set_enpassant?(src,destination,state)
        set_enpassant(src,destination,state)
      else
        state.set_enpassant_tile(nil)
      end
    end

    def self.check_piece_promotion(location,state)
      promote_piece(location,state) if should_promote?(location,state)
    end

    def self.should_promote?(location,state)
      (location[1] == "1" || location[1] == "8") && state.piece(location).piece_type == :Pawn
    end
    def promote_piece(location,state)
      piece_type_to_promote_to = state.params[:application].process_dialog(dialog_type: :promotion_dialog, state: state)
      new_piece = create_piece(piece_type_to_promote_to)
      set_piece(new_piece,location,state)
    end
    def set_piece(piece,location,state)
        ChimaChess::PieceMover.set_piece(piece,location,state)
    end
    def self.reduce_advance(src,state)
      state.piece(src).reduce_advance
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
end
