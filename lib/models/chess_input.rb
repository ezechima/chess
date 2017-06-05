module ChimaChess
	
	MOVE_EXPR = /^([KQRBN]){0,1}([a-h])?([1-8])?(([a-h]{1})([1-8]{1}))$/ 
	CASTLE_EXPR = /([0|O]-[0|O]){1}(-[0|O])?/
	PIECE_TYPES = {:K => :King, :Q => :Queen, :R => :Rook, :B => :Bishop, :N => :Knight, :P => :Pawn}

	class ChessRegularInput

		attr_accessor :destination_tile, :piece_type, :color, :source_rank, :source_file

		def initialize (color,piece_type,destination_tile,source_rank=nil,source_file=nil)
			@color = color
			@piece_type = piece_type
			@destination_tile = destination_tile
			@source_rank = source_rank
			@source_file = source_file
		end

	end

	class ChessCastleInput
		attr_accessor :color, :side

		def initialize(color,castle_side)
			@color = color
			@castle_side = castle_side

		end
	end



end


