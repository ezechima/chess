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
	MOVE_EXPR = /^([KQRBN]){0,1}([a-h])?([1-8])?(([a-h]{1})([1-8]{1}))$/ 
	PIECE_CLASSES = {:K => King, :Q => Queen, :R => Rook, :B => Bishop, :N => Knight, :P =>Pawn}

	def initialize
		@active_board = Chess_Board.new
		@move_array = []
		@white_player = Chess_Player.new("White")
		@black_player = Chess_Player.new("Black")
		@players = [@white_player,@black_player]
		start

	end

	def start
		no_win = true
		render_board
		while (no_win)
			@players.each do |player|
				
				begin
					directive = player.play
					
					process_directive(directive,player)


				rescue Exception => e
					puts e.message

					redo
				end
				render_board
			end
		end
		
	end
	def process_directive(input,player)
		directive = MOVE_EXPR.match(input)
		raise "This is an invalid input" if directive == nil
		piece_class = directive[1] || "P"
		piece_class_str = PIECE_CLASSES[piece_class.to_sym]
		destination = directive[4] 
		source_rank = directive[3]
		source_file = directive [2]
		@active_board.move(player.player_color,piece_class_str,destination,source_rank,source_file)

		
	end
	def render_board(board=nil)
		system "clear"
		@active_board.render_board(@active_board)
	end




	Chess_Play.new
end

=begin

Load Game Board
initialize player classes
monitor for exceptions
receive input from players play method
call board play method
catch exception
put exception and retry
if succesful loop

make save game protocol
=end



