module ChimaChess
	MOVE_EXPR = /^([KQRBN]){0,1}([a-h])?([1-8])?(([a-h]{1})([1-8]{1}))$/
	CASTLE_EXPR = /([0|O]-[0|O]){1}(-[0|O])?/
	PIECE_TYPES = {:K => :King, :Q => :Queen, :R => :Rook, :B => :Bishop, :N => :Knight, :P => :Pawn}
	class MalformExprProcessor
		def self.match(string)
			message = "I don't understand '#{string}'"
			create_malform_exception(message)

		end
		def self.create_malform_exception (message)
			raise ChimaChess::ChessGameException.new(message)

		end

	end

	class GameSessionExprProcessor
		SESSION_EXPR = {"new"=> "new","save"=>"save", "load" => 'load', 'exit' => 'exit'}
		def self.match(string)
			match = SESSION_EXPR[string.downcase]
			send("process_#{match}",string)

		end
		def self.process_(string)
			ChimaChess::MalformExprProcessor.match(string)
		end
		def self.process_new(string)
			puts 'new not implemented'
		end
		def self.process_save(string)
			puts 'save not implemented'
		end
		def self.process_load(string)
			puts "load not implemented"
		end
		def self.process_exit(string)
			puts "exit not implemented"
		end
	end

	class GameStateExprProcessor
		STATE_EXPR = {"undo"=> "undo","redo"=>"redo"}
		def self.match(string)
			match = STATE_EXPR[string.downcase]
			send("process_#{match}",string)

		end
		def self.process_(string)
			ChimaChess::GameSessionExprProcessor.match(string)
		end
		def self.process_undo(string)
			puts "undo not implemented"
		end
		def self.process_redo(string)
				puts 'redo not implemented'
		end
	end


	class CastleExprProcessor
		def self.match(string)
			move_match = CASTLE_EXPR.match(string)
			send("process_#{move_match.class}",move_match||string)

		end
		def self.process_NilClass(string)
			ChimaChess::GameStateExprProcessor.match(string)
		end
		def self.process_MatchData(directive)
			castle_side = directive[2] ? :queen_side : :king_side
			castle_side

		end
	end

	class MoveExprProcessor

		def self.match(string)
			move_match = MOVE_EXPR.match(string)
			send("process_#{move_match.class}",move_match||string)

		end
		def self.process_NilClass(string)
			ChimaChess::CastleExprProcessor.match(string)
		end
		def self.process_MatchData(directive)
			piece_type_char = directive[1] || "P"
			piece_type = PIECE_TYPES[piece_type_char.to_sym]
			destination = directive[4]
			source_rank = directive[3]
			source_file = directive [2]
			#ChessRegularInput.new(get_color,piece_type_sym,destination,source_rank,source_file)
			[piece_type,destination, source_rank, source_file]
		end
	end

	class ChessTextProcessor

		def self.process_input(string)
			ChimaChess::MoveExprProcessor.match(string)
		end

	end
end
