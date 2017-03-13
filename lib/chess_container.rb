class Chess_Tile
	attr_accessor :piece
	def initialize (piece=nil)
		@piece = piece
	end
	def is_empty?
		@piece ? true : false
	end
	def piece
		@piece
	end
	def piece=(piece)
		@piece = piece
	end
	def clear
		@piece = nil
	end
	



end