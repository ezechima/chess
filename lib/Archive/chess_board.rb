


class Chess_Board
require_relative 'point.rb'
require_relative 'chess_tile.rb'
require_relative 'chess_pieces.rb'
require_relative 'render_chess_board.rb'
include Render_Chess_Board

	BOARD_FILE = {"a"=>0,"b"=>1,"c"=>2,"d"=>3,"e"=>4,"f"=>5,"g"=>6,"h"=>7}
	LOC_REGEXP = /([a-h])([1-8])/ #regular Expression representing a location on the chess board using algebraic notation.
	attr_accessor :active_pieces, :board, :black_killed_pieces, :white_killed_pieces, :black_pieces_active, :white_pieces_active, :enpassant_tile
	attr_reader :black_attack_tiles, :white_attack_tiles, :black_king, :white_king, :active_pieces_by_color, :killed_pieces_by_color
	PROMOTION_PIECES = {:Q => "Queen", :N => "Knight", :R => "Rook", :B => "Bishop"}
	def initialize
		@active_pieces=[]
		@black_pieces_active = []
		@white_pieces_active = []
		@black_killed_pieces =[]
		@white_killed_pieces = []
		@active_pieces_by_color = {'white' => @white_pieces_active, 'black' => @black_pieces_active}
		@killed_pieces_by_color = {'white' => @white_killed_pieces, 'black' => @black_killed_pieces}
		@board = Array.new(8) { Array.new(8) {Chess_Tile.new(self)}}
		initialize_tiles  #update tile locations

		place_pieces		#its the board's responsibility to ensure pieces are properly placed
		update_all_attack_tiles


		@black_king = piece('e8')
		@white_king = piece('e1')
		#Castle variables is used to store a hash of kings and rooks
		@castle_variables = {'white' => {'king' => @white_king,'rook_west' => piece('a1'),
			'rook_east' => piece('h1'),'under_attack_by' =>@black_attack_tiles} ,
			'black' => {'king' => @black_king,'rook_west' => piece('a8'),
			'rook_east' => piece('h8'), 'under_attack_by' => @white_attack_tiles}}

		true
	end

	def initialize_tiles
		each do |tile,point|
			tile.location = point
			tile.str_location = to_chess_notation(point)
			#tile.board = self
		end
		true


	end
	#the game always has information about which piece is attacking where
	#after every move, this method should be called to refresh
	def update_all_attack_tiles
		@white_attack_tiles =update_attack_tiles(@white_pieces_active)
		@black_attack_tiles = update_attack_tiles(@black_pieces_active)

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
					new_piece = Object.const_get(piece[2]).new(color,file+rank)
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
				attack_tiles[tile.to_s] =piece  #remooved .to_s
			end


		end
		attack_tiles


	end
	#checks if
	#and finding out if the king is still under check
	def checkmate? (piece_color)
		temp_board = Marshal.load(Marshal.dump(self))
		search_array = temp_board.active_pieces_by_color[piece_color.downcase]
		search_array.each do |piece|
			piece.moveTiles_list.each do |tile_location|
				begin
					move = temp_board.move(piece.color,piece.class,tile_location,tile_location[1],tile_location[0])
				rescue
				end
				if move
					puts "Piece is #{piece}, destination is #{tile_location}"
					return false
				end
			end
		end
		true
	end



	def move(piece_color,piece_class,destination,rank=nil, file=nil)

		#find the piece that fits this move
		found_piece = find_piece(piece_color,piece_class,destination,rank,file)
		found_piece_location=found_piece.get_location
		#create a clone and test the move to see if it is valid
		temp_board = Marshal.load(Marshal.dump(self))


		response = temp_board.move_piece(piece_color,found_piece_location,destination)
		if  response == true #{:move=> true, :message =>"King is under attack by"}
			move = move_piece(piece_color,found_piece_location,destination)
			return move

		end
	end

	def move_piece (piece_color,source_location, destination)
		#move the piece to the required destination
		#update attack tiles
		#check to see if own king is under attack
		source_tile = tile(source_location)
		piece = source_tile.piece

		destination_tile = tile(destination)
		source_tile.clear
		destination_tile.piece = piece

		piece.has_moved = true
		update_all_attack_tiles
		piece_color.downcase == 'white' ? king_check?(@white_king,@black_attack_tiles) : king_check?(@black_king,@white_attack_tiles)
		true

	end
	#checks if the king's position is under attack
	#It can also be used to check if a position is under attack by an opposing piece
	def king_check? (king,list_of_tiles)
		if king.instance_of?(String)
			king_tile= king
		else
			king_tile = king.getTile.to_s
		end
		temp = list_of_tiles[king_tile]
		if temp == nil
			return false
		else
			raise "#{king} is under attack by #{temp}"
		end

	end
	#method to call castle, color is a string of the piece and rook_side is a string telling which rook is moving  could either be rook_east or rook_west
	def castle(color,rook_side)
		color = color.downcase
		direction = rook_side_direction(rook_side)
		rook = @castle_variables[color][rook_side]
		king = @castle_variables[color]['king']
		king_tile = king.getTile
		rook_destination_tile = king_tile.neighbor(direction)
		danger_tiles = @castle_variables[color]['under_attack_by']
		check_if_moved(king,rook)
		check_rook_path(rook, rook_destination_tile)
		check_king_path(king_tile, direction,danger_tiles)
		move_piece(color,king_tile.to_s,king_tile.neighbor(direction*2)	.to_s)					#move king to the side of the rook
		move_piece(color,rook.getTile.to_s,rook_destination_tile.to_s)				#move_rook_to the side of the king



	end

	def rook_side_direction (rook_side)

		rook_side == 'rook_west' ? Chess_Tile::WEST : Chess_Tile::EAST

	end
	#used in castling to check if relevant pieces have moved already
	def check_if_moved(king, rook)
		if king.has_moved
			raise "#{king} has moved already and cannot castle"
		elsif rook.has_moved
			raise "#{rook} has moved already and cannot castle"
		end
		false

	end
	#used in castling to check if the path taken by the king is under check
	def check_king_path(king_tile,direction,danger_tiles)

		0.upto(2) do |num|
			king_check?(king_tile.neighbor(direction * num).to_s,danger_tiles)
		end


	end
	def check_rook_path (rook,rook_destination_tile)
		if rook.moveTiles_list.include?(rook_destination_tile.to_s) && rook_destination_tile.is_empty?
			return true
		else
			raise "Path between #{rook} and King is not clear"
		end

	end
	def kill_piece(piece)
		index=active_pieces.find_index(piece)
		active_pieces.delete_at(index)
		piece_color = piece.color.downcase
		active_piece_array = active_pieces_by_color[piece_color]

		index = active_piece_array.find_index(piece)
		active_piece_array.delete_at(index)
		killed_pieces_by_color[piece_color] << piece

		piece.setTile(nil)



	end
	#promote a pawn once it reaches the eight rank
	def promote_pawn(tile)
		current_piece = tile.piece

		puts "What piece would you like to promote your pawn to: Q: Queen, R: Rook, N: Knight, B: Bishop"
		response = gets.chomp.upcase.to_sym
		promotion_class = PROMOTION_PIECES[response]
		if !promotion_class
			raise " This is an invalid selection"
		else
			promoted_piece = Object.const_get(promotion_class).new(current_piece.color,tile.to_s)
			promoted_piece.setTile(tile)
			@active_pieces_by_color[promoted_piece.color.downcase] << promoted_piece
			tile.piece = promoted_piece


		end

	end


	def find_piece(piece_color,piece_class,destination,rank,file) # (string,class,string location,string rank, string file)
		piece_found = false
		temp_piece = nil

		search_array = active_pieces_by_color[piece_color.downcase]
		search_array.each do |search_piece|
			if search_piece.instance_of?(piece_class)
				piece_found=true
				temp_piece = search_piece
				if search_piece.moveTiles_list.include?(destination)
					if (rank || file) && (search_piece.getTile.rank == rank || search_piece.getTile.file == file)
						return search_piece
					elsif !(rank || file)
						return search_piece
					end
				end
			end
		end
		if piece_found
			raise "#{temp_piece} cannot move to #{destination}"
		else
			raise "#{piece} not in play"
		end
		false

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
	def to_s
		 "ChessBoard #{__id__}"
	end
	def inspect

		"ChessBoard #{__id__}"
	end



end
