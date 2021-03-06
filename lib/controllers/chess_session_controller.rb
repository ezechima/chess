module ChimaChess
	require './lib/controllers/chess_state_controller.rb'
	require './lib/models/session_manager.rb'
	require 'yaml'

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

		def current_state
			state_controller.current_state
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
			reference = application.app_view_controller.render_load_dialog
			session = session_manager.load_session(reference)
			create_state_controller(session)
		end

		def session_IO
			application.session_IO
		end

		def save_session
			reference = application.app_view_controller.render_save_dialog
			session_manager.save_session(reference)
		end

		def exit_session
			#try_save
			application.exit_application
		end

		def create_session_manager
			 ChimaChess::SessionManager.new(self)
		end

		def create_state_controller(session)
			@state_controller = ChimaChess::ChessStateController.new(session)
		end
	end
end
