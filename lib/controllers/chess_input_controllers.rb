module ChimaChess
	MOVE_EXPR = /^([KQRBN]){0,1}([a-h])?([1-8])?(([a-h]{1})([1-8]{1}))$/
	CASTLE_EXPR = /([0|O]-[0|O]){1}(-[0|O])?/
	PIECE_TYPES = {:K => :King, :Q => :Queen, :R => :Rook, :B => :Bishop, :N => :Knight, :P => :Pawn}


	class MessageObject
		attr_reader :message_type, :message
		def initialize(message_type:,message:)
				@message_type = message_type
				@message = message
		end

	end
	class CastleMessageObject < MessageObject
		attr_reader :castle_side, :move_class
		def initialize(castle_side:)
			super(message_type: :state_message, message: :move)
			@castle_side = castle_side
			@move_class = :castle_move
		end
	end
	class MoveMessageObject < MessageObject
		attr_reader :piece_type, :destination, :rank, :file, :move_class
		def initialize(piece_type:, destination:,rank:, file:)
			super(message_type: :state_message, message: :move)
			@piece_type = piece_type
			@destination = destination
			@rank = rank
			@file = file
			@move_class = :regular_move
		end
	end


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
		SESSION_EXPR = {"new"=> :new,"save"=> :save, "load" => :load, 'exit' => :exit}
		def self.match(string)
			match = SESSION_EXPR[string.downcase]
			send("process_#{match.class.to_s}",match||string)

		end
		def self.process_NilClass(string)
			ChimaChess::MalformExprProcessor.match(string)
		end
		def self.process_Symbol(sym)
			ChimaChess::MessageObject.new(message_type: :session_message, message: sym)
		end

	end

	class GameStateExprProcessor
		STATE_EXPR = {"undo"=> :undo,"redo"=> :redo, "reset" => :reset}
		def self.match(string)
			match = STATE_EXPR[string.downcase]
			send("process_#{match.class.to_s}",match||string)

		end
		def self.process_NilClass(string)
			ChimaChess::GameSessionExprProcessor.match(string)
		end
		def self.process_Symbol(sym)
			ChimaChess::MessageObject.new(message_type: :state_message, message: sym)
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
			create_message(castle_side)
		end
		def self.create_message(castle_side)
			ChimaChess::CastleMessageObject.new(castle_side: castle_side)

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
			create_message(piece_type,destination,source_rank,source_file)
		end
		def self.create_message(piece_type,destination,source_rank,source_file)
			ChimaChess::MoveMessageObject.new(
				piece_type: piece_type,
				destination: destination,
				rank: source_rank,
				file: source_file
				)
		end
	end

	class ChessTextProcessor

		def self.process_input(string)
			ChimaChess::MoveExprProcessor.match(string)
		end
	end
end
