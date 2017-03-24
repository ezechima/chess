=begin
Next Steps.. 
Add save capability in order to continue with the right player
Add Castle functionality
Add enpassant Capture
Add random AI Play



=end



class Chess_Player
	attr_accessor :player_name, :player_color

	def play(board=nil)
		@player_type ==  :human ? human_play(board) : computer_play(board)
	end


	def human_play(board=nil)
		puts "[#{@player_color}'s turn] #{@player_name} make your move:"
		return gets.chomp.to_s


	end
	def computer_play(board=nil)
		"d5"
	end
	def initialize(player_color)

		while (true)
			puts "What kind of player is #{player_color}.. Human or Computer?"
			resp = gets.chomp.to_s.downcase[0]
			if resp == 'h'
				@player_color = player_color
				@player_type = :human
				puts "What is your name"
				@player_name = gets.chomp
				break
			elsif resp == 'c'
				@player_type = :computer
				@player_name = "Computer #{self.__id__}"
				break
			end
		
		end
		
	end

end


class Chess_Play
	require_relative 'chess_board.rb'
	require_relative 'save_load.rb'
	include Save_Load
	MOVE_EXPR = /^([KQRBN]){0,1}([a-h])?([1-8])?(([a-h]{1})([1-8]{1}))$/ 
	PIECE_CLASSES = {:K => King, :Q => Queen, :R => Rook, :B => Bishop, :N => Knight, :P =>Pawn}
	attr_accessor :current_player_index

	def initialize
		@active_board = Chess_Board.new
		@move_array = []
		@white_player = Chess_Player.new("White")
		@black_player = Chess_Player.new("Black")
		
		@current_player = @white_player
		@no_win = true
		@exit = false
		#@game_state = [@active_board,@current_player,@players]	
		start

	end

	def start
		
		render_board
		while (@no_win && !@exit)
			player = @current_player
				
			begin
				directive = player.play
				
				process_directive(directive,player)


			rescue Exception => e
				puts e.message

				redo
			end
			render_board
			switch_player
		end
		
	end
	def process_directive(input,player)
		directive = MOVE_EXPR.match(input)
		if directive != nil
			piece_class = directive[1] || "P"
			piece_class_str = PIECE_CLASSES[piece_class.to_sym]
			destination = directive[4] 
			source_rank = directive[3]
			source_file = directive [2]
			@active_board.move(player.player_color,piece_class_str,destination,source_rank,source_file)
		elsif input.to_s.downcase == "undo"
		elsif input.to_s.downcase == "save"
			save_game([@active_board,@current_player,@white_player,@black_player])
			
			render_board
			raise "Game Saved"  # done so as to give the current player an opportunity to make a valid move or quit.
		elsif input.to_s.downcase == "load"
			exit_game
			@exit = false
			game_state = load_game
			@active_board = game_state[0]
			@current_player = game_state[1]
			
			@white_player = game_state[2]
			@black_player = game_state[3]
			render_board
			raise "Game Loaded"
		elsif input.to_s.downcase == "exit"
			exit_game

		else
			raise "This is an invalid input"
		end


		
	end
	def exit_game
		@exit = true
		puts "Do you want to save this game before exiting, y/n"
		response = gets.chomp
		if response[0] == "y"
			save_game([@active_board,@current_player,@players])
			render_board
			puts "Game Saved"  # done so as to give the current player an opportunity to make a valid move or quit.

		end
		
	end
	def render_board(board=nil)
		system "clear"
		@active_board.render_board(@active_board)
	end
	def switch_player
		@current_player= (@current_player == @white_player) ? @black_player : @white_player
		
	end



	Chess_Play.new
end





