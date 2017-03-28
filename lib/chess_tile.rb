class Chess_Tile
	
	attr_accessor  :location, :board, :str_location
	NORTH = Point.new(0,1)
	SOUTH = Point.new(0,-1)
	EAST = Point.new(1,0)
	WEST = Point.new(-1,0)
	def initialize (board=nil)
		@piece = nil
		@board = board
	end
	def is_empty?
		@piece ? false : true
	end

	def can_attack_enpassant?
		@board.enpassant_tile == @str_location
	end
	def set_enpassant
		@board.enpassant_tile = @str_location
		
	end
	def piece
		@piece
	end
	def clear_enpassant_flag
		@board.enpassant_tile = ""
		
	end
	def kill_enpassant
		@board.kill_piece(@piece)
		clear_enpassant_flag
		clear
	end
	def piece=(piece)
		@board.kill_piece(@piece) if @piece 

		@piece = piece
		@piece.setTile(self)
	end
	def clear
		@piece = nil
	end
	def neighbor(direction)
		
		
		@board.tile(@location + direction)
		
	end
	def rank
		@str_location[1]
	end
	def file
		@str_location[0]

		
	end
	def to_s
		@str_location
	end

	def inspect
		@str_location
	end




end