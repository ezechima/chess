module Render_Chess_Board

	require_relative 'point.rb'
	# even- dark, odd : light
	

	HIGHLIGHT_FLAG = "5;"  #1 for brightmode, 4 for underline,  5 for blinkmode
	PLAYER_COLORS = { "white" => 34, "black" => 30 }
	TILE_BACKGROUND = {:light => 47, :dark => 46}
	PIECE_SHAPES = {"king" => "\u2654", "queen" => "\u2655" , "rook" => "\u2656", "knight" => "\u2658", "bishop" => "\u2657", "pawn" => "\u2659"}

	#initialize padding for the tiles on the board



	

	#primary method for rendering gameboard,
	def render_board (board,tile_width=5,tile_height=3)
	
		@tile_width = tile_width
		@tile_height = tile_height
		@top_pad = @tile_height/2
		@bottom_pad = @tile_height-@top_pad-1 
		@bottom_pad = @bottom_pad > 0 ? @bottom_pad : 0
		@left_pad = @tile_width / 2
		@right_pad = @tile_width - @left_pad -1
		@right_pad = @right_pad >0 ? @right_pad : 0	






		rank = 8
		render_letters

		8.times do 
			rank -=1

			render_ranks(rank,board)

		end
		render_letters

		true

	end

	def render_ranks(rank,board)
		files_on_rank = []
		0.upto(7) do |file|
			files_on_rank << Point.new(file,rank)
		end
		@top_pad.times do
			render_pad_spacing(files_on_rank)
		end
		render_pieces(files_on_rank,board)
		@bottom_pad.times do
			render_pad_spacing(files_on_rank)

		end

	end
	def render_pad_spacing(files_on_rank)
		print "  "
		files_on_rank.each do |file|
			tile_shade_str = TILE_BACKGROUND[tile_background_color(file)]
			print "\033[#{tile_shade_str}m#{' '*@tile_width}\033[0m"
		end
		puts ""
		true
			
	end
	def render_pieces(files_on_rank,board)
		print "#{files_on_rank[0].y+1} "

		files_on_rank.each do |file|
			piece = board.piece(file)
			piece_str = PIECE_SHAPES[piece.class.to_s.downcase] || " "
			foreground = piece ? piece.color.downcase : "white"
			background = tile_background_color(file)
			foreground_str = PLAYER_COLORS[foreground]
			background_str = TILE_BACKGROUND[background]
			print "\033[#{foreground_str};#{background_str}m#{' '*@left_pad}#{piece_str}#{' '*@right_pad}\033[0m"


		end
		print " #{files_on_rank[0].y+1} "
		puts ""

		
	end
	def render_letters
		
		print "  "
		"a".upto("h") do |letter|
			print "#{' '*@left_pad}#{letter}#{' '*@right_pad}"
		end
		puts ""

		
	end


	#Tells the shade or background of the tile on the board. 
	#white queen starts on a light shade and vice versa 
	#method takes a location in the string format a6, and gives the shade
	#dark cells are even, while light cells are odd
	def tile_background_color(point_location)
		sum = point_location.x + point_location.y
		return sum % 2 > 0 ? :light : :dark

	
	end

end

	

	