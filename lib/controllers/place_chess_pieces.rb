module ChimaChess
	require './lib/models/chess_pieces.rb'
	require './lib/controllers/piece_creator.rb'

	class PlaceChessPieces
		attr_accessor :piece_positions
		def initialize
			@piece_positions =[]
		end
		def place_chess_pieces(board: , config: "standard", clear_flag: true)

			board = clear_pieces(board) if clear_flag
			board = send("load_#{config}_config",board)
			board
		end

		def create_piece(piece_type:,color:,first_location:)
			ChimaChess::PieceCreator.create_piece(piece_type: piece_type,color: color, first_location: first_location)
		end

		def place_standard_pieces(board)

			piece_positions.each do |piece|
				color = :white
				piece[0].each do |rank|
					piece[1].each do |file|
						new_piece =create_piece(piece_type: piece[2],color: color,first_location: file+rank)
						board.tile(file+rank).piece = new_piece

					end
					color = :black
				end

			end
			board
		end
		def load_standard_config(board)
		   @piece_positions = [	[["2","7"],('a'..'h'),:Pawn],
								[["1","8"],["a","h"],:Rook],
							 	[["1","8"],["b","g"],:Knight],
							 	[["1","8"],["c","f"],:Bishop],
							 	[["1","8"],["d"],:Queen],
							 	[["1","8"],["e"],:King]
							 ]
			place_standard_pieces(board)
		end
		def load_test_config(board)
		   @piece_positions = [	[["2","7"],('a'..'h'),:Pawn],
								[["3","6"],["a","h"],:Rook],
							 	[["4","5"],["b","g"],:Knight],
							 	[["4","5"],["c","f"],:Bishop],
							 	[["3","6"],["d"],:Queen],
							 	[["1","8"],["e"],:King]
							 ]
			place_standard_pieces(board)
		end

		def clear_pieces(board)
			board.each_tile do|tile, point|
				tile.clear_piece
			end
			board


		end


	end
end
