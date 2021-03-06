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
		attr_accessor :list_of_tiles, :attacker_type, :attacker_location, :attacker_color

		def initialize(list_of_tiles: [], attacker_type:, attacker_location:, attacker_color:)
			@list_of_tiles = list_of_tiles
			@attacker_type = attacker_type
			@attacker_location = attacker_location
			@attacker_color = attacker_color
		end

		def include?(str)
			list_of_tiles.include?(str.to_s)
		end
	end

	class AttackList
		attr_accessor :tiles_attacked_by_black, :tiles_attacked_by_white
		def initialize
			reset_list
		end

		def update_attacked_tiles(board)
			reset_list
			board.each_piece do |piece,point|
				send("update_tiles_attacked_by_#{piece.color.to_s.downcase}",piece,point,board)
			end
		end

		def simple_list
			simplified_list = {}
			tiles_attacked_by_white.each do |key,value|
				simplified_list[key] = value.list_of_tiles
			end
			tiles_attacked_by_black.each do |key,value|
				simplified_list[key] = value.list_of_tiles
			end
			simplified_list
		end

		def tiles_attacked
			tiles_attacked_by_white.merge(tiles_attacked_by_black)
		end

		private

		def reset_list
			@tiles_attacked_by_white = {}
			@tiles_attacked_by_black = {}
		end

		def update_tiles_attacked_by_black (piece,point,board)
			 list_of_tiles = piece.update_tiles_attacked(point, board)
			 tiles_attacked_by_black[piece.name] = create_attack_object(list_of_tiles,piece.piece_type,point.to_chess_notation,piece.color)
		end

		def update_tiles_attacked_by_white(piece,point,board)
			 list_of_tiles = piece.update_tiles_attacked(point, board)
			 tiles_attacked_by_white[piece.name] = create_attack_object(list_of_tiles,piece.piece_type,point.to_chess_notation,piece.color)
		end

		def create_attack_object(list_of_tiles,attacker_type,attacker_location,attacker_color)
			AttackObject.new(
				list_of_tiles: list_of_tiles,
				attacker_type: attacker_type,
				attacker_location: attacker_location,
				attacker_color: attacker_color
				)
		end
	end
end
