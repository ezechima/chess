module ChimaChess
  require './lib/controllers/board_creator.rb'
  require './lib/models/game_state_monitor.rb'

	class SessionManager
		attr_accessor :active_session
    attr_reader :session_controller
    def initialize(session_controller = nil)
      @session_controller = session_controller
    end

		def new_session
			@active_session = create_new_session
		end

		def load_session(reference)
			@active_session = session_creator.load(reference: reference)
		end

		def save_session(reference)
			session_writer.save(object: @active_session, reference: reference)
		end

    def create_new_session
			board = create_new_board
      update_board_params(board)
			session = create_state_monitor(board)
			session
		end

    def create_new_board
			ChimaChess::BoardCreator.create()
		end

    def create_state_monitor(board)
			ChimaChess::StateMonitor.new(state_object: board)
		end

    def update_board_params(board)
      board.params[:application] = session_controller.application
    end

    def session_creator
      session_controller.session_IO
    end
    def session_writer
      session_controller.session_IO
    end
	end
end
