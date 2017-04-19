class Chess_Piece
	require_relative 'point.rb'

	NORTH = Point.new(0,1)
	SOUTH = Point.new(0,-1)
	EAST = Point.new(1,0)
	WEST = Point.new(-1,0)
	attr_reader :color,  :attackTiles, :moveTiles, :name
	attr_accessor :has_moved

	#sets the color and current tile for the chess piece
	def initialize (color, first_location)
		@attackTiles = []  #Tiles the piece is attacking
		@currentTile = nil  #Tile the piece is currently on
		@moveTiles = []	#Tiles the piece can move to, equal to attack tile except for pawns
		@color = color		#white or black chess piece
		@has_moved = false
		@name = "#{@color} #{self.class} #{first_location}"
	end
	def has_moved=(bool)
		@has_moved = bool
		
		getTile.clear_enpassant_flag

		
	end

	def attackTiles_list
		@attackTiles.map {|tile| tile.to_s}
	end
	def moveTiles_list
		@moveTiles.map {|tile| tile.to_s}
	end

	def getTile
		@currentTile
	end
	def get_location
		@currentTile.to_s

	end
	def setTile(tile)
		@currentTile = tile
	end



	def can_attack?(tile)

		return true if tile && (tile.is_empty? || tile.piece.color != self.color)
		false

	
	end

	def update_position

	end
	def to_s
		"#{@color} #{self.class} on #{@currentTile}"
	end
	def inspect
		"#{@color} #{self.class} on #{@currentTile} AttackTiles <#{@attackTiles}> moveTiles < #{@moveTiles}>"

	end
	#update attack tiles for pieces which cannot take more than one step in a particular direction
	#pawns, knight, king.
	def update_attackTiles_linear
		@attackTiles = []
		@attack_directions.each do |attack_direction|
			neighbor_tile = @currentTile.neighbor(attack_direction)
			if can_attack?(neighbor_tile)
				@attackTiles << neighbor_tile 
			end
				
		end	
		update_moveTiles
		@attackTiles


	end
	def update_attackTiles_recursive
		@attackTiles = []
		@attack_directions.each do |attack_direction|
			update_attackTiles_in(attack_direction,@currentTile)

		end
		update_moveTiles
		@attackTiles

	end

	private 
	#recursive method to update attack tiles for pieces that can take more than one step in a direction

	def update_attackTiles_in(attack_direction, currentTile)
		neighbor_tile = currentTile.neighbor(attack_direction)
		if neighbor_tile && can_attack?(neighbor_tile)
			@attackTiles << neighbor_tile

			update_attackTiles_in(attack_direction,neighbor_tile) unless neighbor_tile.piece
		end

	end


end

class Queen < Chess_Piece
	def initialize (color, first_location)
		super
		@attack_directions = [NORTH, WEST, EAST, SOUTH,NORTH + EAST, NORTH + WEST, SOUTH+EAST, SOUTH+ WEST]
		@move_directions = @attack_directions
	end
	def update_attackTiles
		update_attackTiles_recursive

	end
	def update_moveTiles
		@moveTiles = @attackTiles
	end	


end

class King < Chess_Piece
	def initialize (color, first_location)
		super
		@attack_directions = [NORTH, WEST, EAST, SOUTH,NORTH + EAST, NORTH + WEST, SOUTH+EAST, SOUTH+ WEST]
		@move_directions = @attack_directions
	end
	def update_attackTiles
		update_attackTiles_linear

	end
	def update_moveTiles
		@moveTiles = @attackTiles
	end	

end

class Rook < Chess_Piece
	def initialize (color, first_location)
		super
		@attack_directions = [NORTH, WEST, EAST, SOUTH]
		@move_directions = @attack_directions
	end
	def update_attackTiles
		update_attackTiles_recursive

	end
	def update_moveTiles
		@moveTiles = @attackTiles
	end

end



class Bishop < Chess_Piece
	def initialize(color, first_location)
		super
		@attack_directions = [NORTH + EAST, NORTH + WEST, SOUTH+EAST, SOUTH+ WEST]
		@move_directions = @attack_directions
	end
	def update_attackTiles
		update_attackTiles_recursive

	end
	def update_moveTiles
		@moveTiles = @attackTiles
	end
end
class Knight < Chess_Piece
	def initialize(color, first_location)
		super
		knight_moves = [[1,2],[1,-2],[-1,2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
		@attack_directions = knight_moves.map do |knight_move|
			x,y,z = knight_move
			Point.new(x.to_i,y.to_i,z.to_i)
		end
		@move_directions = @attack_directions
	end
	def update_attackTiles
		update_attackTiles_linear
	

	end
	def update_moveTiles
		@moveTiles = @attackTiles
	end

end
class Pawn < Chess_Piece
	attr_accessor :attack_directions
	attr_reader :enpassant_rank
	def initialize (color, first_location)
		super
		if color.downcase == 'white'
			@attack_directions = [NORTH + EAST, NORTH + WEST]
			@move_directions = [NORTH,NORTH + NORTH]
			@enpassant_rank = "4"
			@promotion_rank = "8"
			@enpassant_tile_direction = SOUTH
		elsif color.downcase == 'black'
			@attack_directions = [SOUTH + EAST, SOUTH + WEST]
			@move_directions = [SOUTH,SOUTH + SOUTH]
			@enpassant_rank = "5"
			@promotion_rank = "1"
			@enpassant_tile_direction = NORTH
		end			

	end
	def update_attackTiles
		update_attackTiles_linear

	end
	def has_moved=(bool)
		@move_directions = [@move_directions[0]]
		if !has_moved && getTile.rank == @enpassant_rank
			getTile.neighbor(@enpassant_tile_direction).set_enpassant
			@has_moved = true
			return
		end
		#Pawn attack directions include tiles flagged enpassant
		#check if this pawn has moved to an enpassant tile, if so then kill the pawn that flagged it
		if getTile.can_attack_enpassant?
			getTile.neighbor(@enpassant_tile_direction).kill_enpassant
		end
		if getTile.rank == @promotion_rank
			return getTile.promote_pawn
		end

		super(bool)
		
	end
	def update_moveTiles
		#@move_directions = [@move_directions[0]] if has_moved # to change, move_directions should be updated when the pieces move method is called
		@moveTiles=[]
		@move_directions.each do |move_direction| 
			neighbor_tile = @currentTile.neighbor(move_direction)
			if neighbor_tile && neighbor_tile.is_empty? 
				@moveTiles << neighbor_tile
			else
				break
			end
		end
		@attackTiles.each do |tile|
			if !tile.is_empty? || tile.can_attack_enpassant?
				@moveTiles = @moveTiles + [tile]
			end
		end
		@moveTiles
	end



end


