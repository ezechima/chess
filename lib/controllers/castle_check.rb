module ChimaChess

	CASTLE_COLOR = {:black => '8', :white => '1'}
	ROOK_POSITION = {:king_side =>'h',:queen_side =>'a'}
	KING_POSITION = 'e'
	ROOK_DESTINATION = {:king_side => 'f', :queen_side => 'd'}
	KING_DESTINATION = {:king_side => 'g', :queen_side => 'c'}

	class CastleMoveChecker

		def self.check(board:, rook_position:,king_position:)
			check_piece(board, rook_position,:Rook)
			check_piece(board, king_position, :king)
		end

		def self.check_piece(board, piece_position,piece_type)
			piece = board.piece(piece_position)
			if piece && piece.piece_type == piece_type && !piece.has_moved?
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

		def self.check(board:, rook_position:, king_position:)
			move_range = generate_move_range(king_position, rook_position)
			move_range.each{|location| create_LOS_exception(board.piece(location)) if !board.tile(location).is_empty?}
			true
		end

		def create_LOS_exception(piece)
			message = "There is a #{piece.piece_type} on #{piece.location}"
			raise ChimaChess::ChessGameException.new(message)
		end

	end

	class CastleCheck

		def self.check (side:, color:, board:)
			color_index = CASTLE_COLOR[color]
			var_rook_position = ROOK_POSITION[side]+color_index
			var_rook_destination = ROOK_DESTINATION[side] + color_index
			var_king_position = KING_POSITION + color_index
			var_king_destination = KING_DESTINATION[side] + color_index
			var_king_move_range = get_king_move_range(side,color_index)
			begin
				ChimaChess::CastleMoveChecker.check(board: board, rook_position: var_rook_position, king_position: var_king_position)
				ChimaChess::CastleLOSChecker.check(board: board, rook_position: var_rook_position, king_position: var_king_position)
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
			(KING_POSITION..KING_DESTINATION[side]).to_a.collect{|file| file+color_index}
		end

	end

end
=begin
			identify pieces
			check if the pieces involved have moved
			check if the there is line of sight
			check if line of sight is under attack

			depends on Attack_list
			depends on ChessBoard
=end
