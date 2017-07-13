module ChimaChess


	class ChessTile

		attr_accessor   :piece
		attr_reader   	:location

		def initialize (point=nil)
			@location = point


		end

		def is_empty?
			@piece.nil?

		end

		def to_s
			location.to_chess_notation
		end
		def clear_piece
			@piece && @piece.set_location("")
			@piece = nil

		end

		def piece=(piece)
			piece.set_location(to_s)
			@piece = piece
		end





	end




end
