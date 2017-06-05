module ChimaChess

	class ChessInputInterpreter

		def create_chess_input_object
			input_string = get_input_string
			get_directive(input_string)

		end

		def get_directive(input_string)
			move_directive = MOVE_EXPR.match(input_string)
			castle_directive = CASTLE_EXPR.match(input_string)
			if move_directive
				return process_move_directive(move_directive)
			elsif castle_directive
				return process_castle_directive(castle_directive)
			else
				raise ChessGameException("Invalid input")
			end

			
		end

		def process_move_directive (directive)
			piece_type = directive[1] || "P"
			piece_type_sym = PIECE_TYPES[piece_type]
			destination = directive[4] 
			source_rank = directive[3]
			source_file = directive [2]
			ChessRegularInput.new(get_color,piece_type_sym,destination,source_rank,source_file)
		end
		
		def process_castle_directive(directive)
			castle_side = castle_directive[2] ? :queen_side : :king_side
			ChessCastleInput.new(get_color,castle_side)
		end

		def get_input_string
			
		end
		def get_color
		end
	end
end
