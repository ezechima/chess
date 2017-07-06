module ChimaChess

	CASTLE_COLOR = {:black => '8', :white => '1'}
	CASTLE_MOVE_RANGE = {:king_side => ('e'..'h'), :queen_side => ('a'..'e')}
	KING_MOVE_RANGE = {:king_side => ('e'..'g'), :queen_side => ('c'..'e')}
	ROOK_POSITION_FILE = {:king_side =>'h',:queen_side =>'a'}
	KING_POSITION_FILE = 'e'
	ROOK_DESTINATION_FILE = {:king_side => 'f', :queen_side => 'd'}
	KING_DESTINATION_FILE = {:king_side => 'g', :queen_side => 'c'}

	class CastleMoveChecker

		def self.check(board:, rook_position:,king_position:)
			check_piece(board, rook_position,:Rook)
			check_piece(board, king_position, :King)
		end

		def self.check_piece(board, piece_position,piece_type)
			piece = board.piece(piece_position)
			if piece && (piece.piece_type == piece_type) && !piece.has_moved?
				return true
			else
				create_move_exception(piece_type, piece_position)
			end
			true
		end

		def self.create_move_exception(piece_type,piece_position)
			message = "#{piece_type} on #{piece_position} has moved"
			raise ChimaChess::ChessGameException.new(message)
		end

	end

	class CastleLOSChecker

		def self.check(board:, castle_move_range:)
			move_range = remove_extremes(castle_move_range)
			move_range.each{|location| create_LOS_exception(board.piece(location)) if !board.tile(location).is_empty?}
			true
		end

		def self.create_LOS_exception(piece)
			message = "There is a #{piece.piece_type} on #{piece.location}"
			raise ChimaChess::ChessGameException.new(message)
		end

		def self.remove_extremes(castle_move_range)
			castle_move_range[1...-1]
		end

	end

	class CastleCheck

		def self.check (side:, color:, board:)
			color_index = CASTLE_COLOR[color]
			var_rook_position = ROOK_POSITION_FILE[side]+color_index
			var_rook_destination = ROOK_DESTINATION_FILE[side] + color_index
			var_king_position = KING_POSITION_FILE + color_index
			var_king_destination = KING_DESTINATION_FILE[side] + color_index
			var_king_move_range = get_king_move_range(side,color_index)
			var_castle_move_range = get_castle_move_range(side,color_index)
			begin
				ChimaChess::CastleMoveChecker.check(board: board, rook_position: var_rook_position, king_position: var_king_position)
				ChimaChess::CastleLOSChecker.check(board: board, castle_move_range: var_castle_move_range)
				ChimaChess::AttackCheck.check(board: board,tiles: get_king_move_range,color: color)
			rescue ChimaChess::ChessGameException => exc

				raise ChimaChess::ChessGameException.new("Cannot Castle: #{exc.message}")

			end
			{ rook_position: var_rook_position,
				rook_destination:var_rook_destination,
				king_position: var_king_position,
				king_destination: var_king_destination
			}
		end

		def self.get_king_move_range(side,color_index)
			KING_MOVE_RANGE[side].collect{|file| file+color_index}
		end

		def self.get_castle_move_range(side,color_index)
			CASTLE_MOVE_RANGE[side].collect{|file| file+color_index}
		end

	end

end
