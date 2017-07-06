module ChimaChess
	require './lib/controllers/move_controller.rb'
	class ChessStateController
		attr_accessor :state_monitor
		def initialize(state_monitor)
			@state_monitor = state_monitor
		end

		def process(message)
			send("#{message.message}",message)
		end
		def reset(message)
			state_monitor.reset_state
		end
		def undo(message)
			state_monitor.previous_state

		end
		def redo(message)
			state_monitor.next_state

		end
		def commit(state)
			state_monitor.add_state(state)

		end
		def current_state
			state_monitor.current_state

		end
		def move(message)
			new_state = process_move(message: message, state: current_state)
			new_state.switch_player
			commit(new_state)
		end
		def process_move(message:, state:)
			ChimaChess::MoveController.process(message: message, state: state)

		end
	end
end
