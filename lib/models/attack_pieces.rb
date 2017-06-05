module ChimaChess

	class ActivePieces
		attr_accessor :black_active_pieces, :white_active_pieces

		def initialize
			@black_active_pieces = {}
			@white_active_pieces = {}
		end


		def update_active_pieces(board)

			board.each_piece do |piece|
				send("update_#{piece.color.to_s.downcase}_pieces",piece)
			end
		end

		def update_black_pieces (piece)
			black_active_pieces[piece.name]=piece
		end

		def update_white_pieces (piece)
			white_active_pieces[piece.name]=piece
			
		end


	end

	class AttackObject
		attr_accessor :list_of_tiles, :attacker_class, :attacker_location

		def initialize(list_of_tiles=[], attacker_class, attacker_location)
			@list_of_tiles = list_of_tiles
			
		end


	end
	class AttackTiles
		attr_accessor :tiles_attacked_by_black, :tiles_attacked_by_white

		def initialize
			@tiles_attacked_by_white = {}
			@tiles_attacked_by_black = {}
		end

		def update_attack_tiles(board)
			board.each_piece do |piece,point|
				send("update_tiles_attacked_by_#{piece.color.to_s.downcase}",piece,point,board)
			end


		end

		def update_tiles_attacked_by_black (piece,point,board)
			 list_of_tiles = piece.update_tiles_attacked(point, board)
			 tiles_attacked_by_black[piece.name] = AttackObject.new(list_of_tiles,piece.class,point)

		end

		def update_tiles_attacked_by_white(piece,point,board)
			 list_of_tiles = piece.update_tiles_attacked(point, board)
			 tiles_attacked_by_white[piece.name] = AttackObject.new(list_of_tiles,piece.class,point)
		end


	end


end
