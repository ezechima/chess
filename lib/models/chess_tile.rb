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
		



	end




end