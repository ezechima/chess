module ChimaChess
	require './lib/models/chess_tile.rb'
	require './lib/helpers/point.rb'
	class ChessBoard
		attr_accessor :board, :turn_to_play,
		attr_reader :enpassant_tile

		def initialize
			@board = {}
			@turn_to_play = :white
			@enpassant_tile = nil

			(0..7).each do |x|
				@board[x] = {}
				(0..7).each do |y|
					@board[x][y]=ChessTile.new(Point.new([x,y]))
				end
			end
		end

		def tile(location)
			location = Point.new(location)
			begin
				board[location.x][location.y]
			rescue
				nil
			end
		end

		def piece(location)
			tile(location).piece
		end

		def each_tile
			y_loc = 0
			x_loc = 0
			@board.each do |x,column|
				column.each do |y,tile|
					yield(tile,Point.new(x,y))
				end
			end
			true
		end

		def each_piece
			each_tile do|tile,point|
				yield(tile.piece,point) if !tile.is_empty?
			end
		end

		def switch_player
			turn_to_play = (turn_to_play == :white ? :black : :white)
		end

		def set_enpassant_tile(tile_str)
			@enpassant_tile = tile_str
		end
	end
end
