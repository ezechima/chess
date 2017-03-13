


class Chess_Board
require_relative 'point.rb'
require_relative 'chess_tile.rb'
require_relative 'chess_pieces.rb'

	BOARD_FILE = {"a"=>0,"b"=>1,"c"=>2,"d"=>3,"e"=>4,"f"=>5,"g"=>6,"h"=>7}
	LOC_REGEXP = /([a-h])([1-8])/ #regular Expression representing a location on the chess board using algebraic notation.
	attr_accessor :active_pieces, :board, :taken_pieces, :black_pieces_active, :white_pieces_active
	attr_reader :black_attack_tiles, :white_attack_tiles

	def initialize
		@active_pieces=[]
		@black_pieces_active = []
		@white_pieces_active = []
		@taken_pieces =[]
		@board = Array.new(8) { Array.new(8) {Chess_Tile.new(self)}}
		initialize_tiles  #update tile locations
		
		place_pieces		#its the board's responsibility to ensure pieces are properly placed
		@white_attack_tiles =update_attack_tiles(@white_pieces_active)
		@black_attack_tiles = update_attack_tiles(@black_pieces_active)

		true
	end
	def place_pieces
		piece_positions = [	[["2","7"],('a'..'h'),'Pawn'],
							[["1","8"],["a","h"],'Rook'],
						 	[["1","8"],["b","g"],'Knight'],
						 	[["1","8"],["c","f"],'Bishop'],	
						 	[["1","8"],["d"],'Queen'],
						 	[["1","8"],["e"],'King']
						 ]

		piece_positions.each do |piece|
			color = 'White'
			piece[0].each do |rank|
				piece[1].each do |file|
					new_piece = Object.const_get(piece[2]).new(color)
					tile(file+rank).piece = new_piece
					@active_pieces << 	new_piece
					if color=='White'
						@white_pieces_active << new_piece
					elsif color == "Black"
						@black_pieces_active << new_piece
					end



				end
				color = "Black"
			end

		end
		true
	end
	def update_attack_tiles (pieces_active)
		attack_tiles = {}
		
		pieces_active.each do |piece|
			piece_attack_tiles = piece.update_attackTiles
			piece_attack_tiles.each do |tile|
				attack_tiles[tile.to_s] =piece.to_s
			end

		
		end
		attack_tiles

		
	end

	def initialize_tiles
		each do |tile,point|
			tile.location = point
			tile.str_location = to_chess_notation(point)
			#tile.board = self
		end
		true

		
	end

	def each
		y_loc = 0
		x_loc = 0
		@board.each do |y|
			y.each do |tile|
				yield(tile,Point.new(x_loc,y_loc))
				x_loc += 1
			end
			x_loc = 0
			y_loc +=1

		end
		true

	end

	#method to return a chess tile given a location
	def tile(location)
		
		location = to_point(location)
		if (0..7) === location.x && (0..7) === location.y
			return @board[location.y][location.x]
		end
		nil


	end
	def piece(location)
		tile(location) ? tile(location).piece : nil

	end
	#to_chess_notation, takes a point on a board, and returns the chess_notation 'e8','d5' etc
	#a1 is represented by Point(0,0), h8 is represented by Point(7,7), 'b4' is represented by Point(1,3)
	def to_chess_notation(point)

		"#{BOARD_FILE.key(point.x)}#{(point.y+1).to_s}"

	end
	def to_point(chess_notation)
		return chess_notation if chess_notation.instance_of?(Point)
		loc = LOC_REGEXP.match(chess_notation)
		if loc.nil?
			raise "Invalid Chess location"
		else
			file = loc[1]
			rank = loc[2]
			return Point.new(BOARD_FILE[file],rank.to_i-1)
		end

	end


end
