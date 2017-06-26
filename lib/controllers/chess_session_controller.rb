module ChimaChess
	class ChessSessionController
		attr_accessor :session_manager, :state_controller
		attr_reader  :application

		def initialize(application)
			@application = application
			@session_manager = create_session_manager
		end
		def process(message)
			send("process_#{message.message_type}",message)

		end
		def process_session_message(message)
			send("#{message.message}_session")

		end
		def process_state_message(message)
			state_controller.process(message)
			
		end

		def new_session
			session = session_manager.new_session
			create_state_controller(session)

		end
		def load_session
			session = session_manager.load_session
			create_state_controller(session)
		end
		def save_session
			session_manager.save_session
		end
		def exit_session
			try_save
			application.exit
		end

		def create_session_manager
			 ChimaChess::SessionManager.new()

		end
		def create_state_controller(session)
			state_controller = ChimaChess::ChessStateController.new(session)

		end

	end
end
