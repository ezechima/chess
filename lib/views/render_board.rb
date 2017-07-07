module ChimaChess
	require './lib/helpers/point.rb'

	SPECIAL_BACKGROUND = {:error => 41, :good => 42}
  HIGHLIGHT_FLAG = "5;"  #1 for brightmode, 4 for underline,  5 for blinkmode
  PLAYER_COLORS = { :white => 34, :black => 30 }
  TILE_BACKGROUND = {:light => 47, :dark => 46}
  PIECE_SHAPES = {:King => "\u2654", :Queen => "\u2655" , :Rook => "\u2656", :Knight => "\u2658", :Bishop => "\u2657", :Pawn => "\u2659"}
	class BackgroundColorCheck

		def self.get_background(view_params:,tile_location:)
			special_formating = check_special_formatting(view_params,tile_location)
			special_formating || tile_background_color(tile_location)
		end
		def self.check_special_formatting(view_params,tile_location)
			special_formating = view_params[tile_location]
			special_formating && SPECIAL_BACKGROUND[special_formating]
		end
		def self.get_location_sum(tile_location)
			point = ChimaChess::Point.new(tile_location)
			sum = point.x + point.y
		end

		def self.tile_background_color(tile_location)
			sum = get_location_sum(tile_location)
		  background_shade =  sum % 2 > 0 ? :light : :dark
			TILE_BACKGROUND[background_shade]
		end
	end
	class RenderBoard
	  def self.render(board:,**params)
	    view_params = initialize_border_params(params)
	    render_file_headings(view_params)
	    8.downto(1) do |rank|
	      render_ranks( board: board, view_params: view_params, rank_str: rank.to_s)
	    end
	    render_file_headings(view_params)
	    true
	  end

	  def self.initialize_border_params(params={})
			tile_width = params[:tile_width] || 5
			tile_height = params[:tile_height] || 3
	    view_params = {}
	    view_params[:tile_width] = tile_width
	    view_params[:tile_height] = tile_height
	    view_params[:top_pad] = tile_height / 2
	    bottom_pad = tile_height - view_params[:top_pad] - 1
	    view_params[:bottom_pad] = bottom_pad > 0 ? bottom_pad : 0
	    view_params[:left_pad] = tile_width / 2
	    right_pad = tile_width - view_params[:left_pad] -1
	    view_params[:right_pad] = right_pad > 0 ? right_pad : 0
	    view_params
	  end

	  def self.rank_range
	    ('a'..'h')
	  end

	  def self.render_file_headings(view_params)
	    print "  "
	    rank_range.each do |letter|
	      print "#{' ' * view_params[:left_pad]}"
	      print letter
	      print "#{' ' * view_params[:right_pad]}"
	    end
	    puts ""
	  end

	  def self.get_rank_tiles_loc(rank_str)
	    rank_range.collect {|file| file + rank_str}
	  end

	  def self.render_ranks(board:, view_params:, rank_str:)
	    rank_tiles_loc = get_rank_tiles_loc(rank_str)
	    render_vertical_pads(rank_tiles_loc, view_params,:top_pad)
	    render_pieces(board: board,rank_tiles_loc: rank_tiles_loc,view_params: view_params)
	    render_vertical_pads(rank_tiles_loc, view_params,:bottom_pad)
	  end

		def self.render_vertical_pads(rank_tiles_loc, view_params,padding_type)
			view_params[padding_type].times { render_vertical_pad(rank_tiles_loc,view_params)}
		end

	  def self.render_vertical_pad(rank_tiles_loc, view_params)
	    print "  "
	    rank_tiles_loc.each do |tile_loc|
	      tile_background = get_background(view_params,tile_loc)
				content =  ' ' * view_params[:tile_width]
	      format_print(background: tile_background, content: content)
	    end
	    puts ""
	    true
	  end

		def self.rank_header(rank_tiles_loc)
			"#{rank_tiles_loc[0][1]} "
		end

		def self.get_piece_str(piece)
			piece_str = piece ? PIECE_SHAPES[piece.piece_type] : " "
		end

		def self.get_foreground(piece)
			foreground_color = piece ? piece.color : :white
			foreground = PLAYER_COLORS[foreground_color]
		end

		def self.get_background(view_params,tile_loc)
			ChimaChess::BackgroundColorCheck.get_background(tile_location: tile_loc,view_params: view_params)
		end

		def self.format_print(highlight: 0, foreground: 34, background: 40, content: "")
			print "\033["
			print "#{highlight};"
			print "#{foreground};"
			print "#{background}m"
			print "#{content}"
			print "\033[0m"
		end

		def self.pad(piece_str,view_params)
			' ' * view_params[:left_pad] + piece_str + ' ' * view_params[:right_pad]
		end

	  def self.render_pieces(board:, rank_tiles_loc:,view_params:)
	    print rank_header(rank_tiles_loc)
	    rank_tiles_loc.each do |tile_loc|
				piece = board.piece(tile_loc)
	      piece_str = get_piece_str(piece)
	      foreground = get_foreground(piece)
	      background = get_background(view_params,tile_loc)
				content = pad(piece_str, view_params)
	      format_print(foreground: foreground, background: background, content: content)
	    end
	    print rank_header(rank_tiles_loc)
	    puts ""
	  end
	end
end
