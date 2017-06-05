module ChimaChess
	require './chess_tile.rb'
	require '../helpers/point.rb'
	class ChessBoard
		attr_accessor :board

		def initialize
			@board = []
			
			(0..7).each do |x|
				@board[x] = []
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
		def tiles_in_direction(direction)

			
		end

		def piece(location)
			tile(location).piece
		end

		def each_tile
			y_loc = 0
			x_loc = 0
			@board.each do |x|
				x.each do |tile|
					yield(tile,Point.new(x_loc,y_loc))
					y_loc += 1
				end
				y_loc = 0
				x_loc +=1

			end
			true
		end

		def each_piece
			each_tile do|tile,point|
				yield(tile.piece,point) if !tile.is_empty?
			end
		end

	end


end