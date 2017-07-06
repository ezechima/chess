module ChimaChess
	require './lib/helpers/point.rb'
	class ChessPiece



		attr_reader :color, :first_location, :location, :attack_directions, :move_directions, :deg_of_freedom, :name, :piece_type
 		attr_accessor :has_moved


		#sets the color and current tile for the chess piece
		def initialize (color:, first_location:)
			@first_location = first_location
			@color = color		#white or black chess piece
			@name = "#{@color} #{piece_type} #{first_location}"
			@deg_of_freedom = 16  #maximum number of steps pieces can move in each direction,
														#it is one for pawns, kings and Knights
			@has_moved = false
		end

		def update_tiles_attacked (point, board)

			attacked_tiles = []

			attack_directions.each do |direction|				#for each direction

				freedom = deg_of_freedom						#initialize the range of motion
				next_point = point + direction
				tile  = board.tile(next_point)
				while (!tile.nil? && tile.is_empty? && (freedom > 0)) do
					attacked_tiles.push(tile.to_s)
					next_point = next_point + direction
					tile = board.tile(next_point)
					freedom -= 1
				end
				attacked_tiles.push(tile.to_s) if ( enemy_position?(tile) && (freedom > 0))
			end
			attacked_tiles

		end

		def enemy? (piece)
			!(color == piece.color)
		end

		def enemy_position?(tile)
			!tile.nil? && !tile.is_empty? && enemy?(tile.piece)
		end

		def set_location(location)
			@location = location
		end

		def has_moved?
			has_moved

		end



		def to_s
			"#{@color} #{piece_type}"
		end





	end

	class Queen < ChessPiece

		def initialize (color:, first_location:)
			@piece_type = :Queen
			super
			@attack_directions = [NORTH, WEST, EAST, SOUTH,NORTH + EAST, NORTH + WEST, SOUTH+EAST, SOUTH+ WEST]
			@move_directions = @attack_directions
		end


	end

	class King < ChessPiece
		attr_accessor :has_moved
		def initialize (color:, first_location:)
			@piece_type = :King
			super
			@deg_of_freedom = 1
			@attack_directions = [NORTH, WEST, EAST, SOUTH,NORTH + EAST, NORTH + WEST, SOUTH+EAST, SOUTH+ WEST]
			@move_directions = @attack_directions
		end


	end

	class Rook < ChessPiece
		attr_accessor :has_moved
		def initialize (color:, first_location:)
			@piece_type = :Rook
			super
			@attack_directions = [NORTH, WEST, EAST, SOUTH]
			@move_directions = @attack_directions
		end


	end



	class Bishop < ChessPiece
		def initialize (color:, first_location:)
			@piece_type = :Bishop
			super
			@attack_directions = [NORTH + EAST, NORTH + WEST, SOUTH+EAST, SOUTH+ WEST]
			@move_directions = @attack_directions
		end

	end
	class Knight < ChessPiece
		def initialize (color:, first_location:)
			@piece_type = :Knight
			super
			@deg_of_freedom = 1
			knight_moves = [[1,2],[1,-2],[-1,2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
			@attack_directions = knight_moves.map do |knight_move|
				x,y,z = knight_move
				Point.new(x.to_i,y.to_i,z.to_i)
			end
			@move_directions = @attack_directions
		end


	end
	class Pawn < ChessPiece
		attr_accessor :has_moved

		def initialize (color:, first_location:)
			@piece_type = :Pawn
			super
			@deg_of_freedom = 1
			if color.to_s.downcase == 'white'
				@attack_directions = [NORTH + EAST, NORTH + WEST]
				@move_directions = [NORTH, NORTH + NORTH]
			elsif color.to_s.downcase == 'black'
				@attack_directions = [SOUTH + EAST, SOUTH + WEST]
				@move_directions = [SOUTH,SOUTH + SOUTH]
			end

		end

		def reduce_advance
			@move_directions = [@move_directions[0]]
		end

		def update_tiles_attacked (point, board)
			attacked_tiles = []

			attack_directions.each do |direction|
				tile  = board.tile(point + direction)
				attacked_tiles.push(tile.to_s) if enemy_position?(tile) || can_attack_enpassant?(tile,board)
			end

			move_directions.each do |direction|
				tile = board.tile(point+direction)
				attacked_tiles.push(tile.to_s) if (!tile.nil? && tile.is_empty?)
			end
			attacked_tiles
		end

		def can_attack_enpassant?(tile,board)
			!tile.nil? && (tile.to_s == board.enpassant_tile)
		end
	end
end
