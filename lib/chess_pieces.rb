class Chess_Piece
	require_relative 'point.rb'

	NORTH = Point.new(0,1)
	SOUTH = Point.new(0,-1)
	EAST = Point.new(1,0)
	WEST = Point.new(-1,0)
	attr_reader :color, :has_moved, :attackTiles, :moveTiles

	#sets the color and current tile for the chess piece
	def initialize (color)
		@attackTiles = []  #Tiles the piece is attacking
		@currentTile = nil  #Tile the piece is currently on
		@moveTiles = []	#Tiles the piece can move to, equal to attack tile except for pawns
		@color = color		#white or black chess piece
		@has_moved = false
	end
	#update attack tiles for pieces which cannot take more than one step in a particular direction
	#pawns, knight, king.
	def update_attackTiles_linear
		@attackTiles = []
		@attack_directions.each do |attack_direction|
			neighbor_tile = @currentTile.neighbor(attack_direction)
			@attackTiles << neighbor_tile if can_attack?(neighbor_tile)
				
		end	
		@attackTiles


	end

	def getTile
		@currentTile
	end
	def setTile(tile)
		@currentTile = tile
	end


	def update_moveTiles
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
	def update_attackTiles_recursive
		@attackTiles = []
		@attack_directions.each do |attack_direction|
			update_attackTiles_in(attack_direction,@currentTile)

		end
		@attackTiles

	end

	private 
	#recursive method to update attack tiles for pieces that can take more than one step in a direction

	def update_attackTiles_in(attack_direction, currentTile)
		neighbor_tile = currentTile.neighbor(attack_direction)
		if neighbor_tile && can_attack?(neighbor_tile)
			@attackTiles << neighbor_tile
			update_attackTiles_in(attack_direction,neighbor_tile)
		end

	end


end

class Queen < Chess_Piece
	def initialize (color)
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
	def initialize (color)
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
	def initialize (color)
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

class Pawn < Chess_Piece
	attr_accessor :attack_directions
	def initialize (color)
		super
		if color.downcase == 'white'
			@attack_directions = [NORTH + EAST, NORTH + WEST]
			@move_directions = [NORTH,NORTH + NORTH]
		elsif color.downcase == 'black'
			@attack_directions = [SOUTH + EAST, SOUTH + WEST]
			@move_directions = [SOUTH,SOUTH + SOUTH]
		end			

	end
	def update_attackTiles
		update_attackTiles_linear

	end
	def update_moveTiles
		move_directions = [NORTH] if has_moved? # to change, move_directions should be updated when the pieces move method is called

		move_directions.each do |move_direction| 
			neighbor_tile = @currentTile.neighbor(move_direction)
			if neighbor_tile.is_empty? || (neighbor_tile.color != @color)
				@moveTiles << neighbor_tile
			end
		end
	end



end

class Bishop < Chess_Piece
	def initialize(color)
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
	def initialize(color)
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


