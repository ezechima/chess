module ChimaChess
  require './lib/controllers/board_creator.rb'

	class SessionManager
		attr_accessor :active_session

		def new_session
			active_session = create_new_session
		end

		def load_session
			#active_session = session_creator.load
		end

		def save_session

			#session_writer.write(active_session)
		end
		def create_new_session
			board = board_creator.create_new_board
			session = create_state_monitor(board)
			session
		end
		def create_new_board
			ChimaChess::BoardCreator.create()
		end
		def create_state_monitor(board)
			ChimaChess::StateMonitor.new(board)
		end
	end
end
