module ChimaChess
	class ChessStateController
		attr_accessor :state_monitor
		def initialize(state_monitor)
			@state_monitor = state_monitor
		end

		def process_request(request)
			request_id = request.request_id
			send("#{request_id}")

		end
		def reset
			state_monitor.reset_state
		end
		def undo
			state_monitor.previous_state

		end
		def redo
			state_monitor.next_state

		end
		def commit(state)
			state_monitor.add_state(state)

		end
		def move
			new_state = move_controller.process_request(request)
			commit(new_state)
		end
	end
end
