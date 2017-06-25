class StateMonitor
	attr_reader :state_objects, :index

	def initialize(state_object:)
		@state_objects = [state_object]
		@index = 0
	end

	def previous_state
		reduce_index
		current_state

	end
	def next_state
		next_index
		current_state
	end

	def add_state (state_object)
		increase_index
		push_state_objects(state_object)


	end

	def current_state
		my_object = state_objects[index]
		create_working_object (my_object)
	end

	def reset_state
		reset_index
		current_state
	end
	private
	def size
		state_objects.size

	end
	def reduce_index
		@index -= 1 if @index > 0
	end

	def increase_index
		@index += 1
		if @index < size
			compact_state_objects
		elsif @index > size
			reset_index
		end

	end
	def next_index
		@index += 1 if @index < (size - 1)
	end

	def reset_index
		@index = size -1
	end

	def compact_state_objects
		pop_times = size - index
		pop_times.times {pop_state_objects}


	end
	def pop_state_objects
		@state_objects.pop

	end
	def push_state_objects(state_object)
		@state_objects.push(state_object)
	end

	def create_working_object (object)
		object.clone

	end


end

class GameStateObject
	attr_reader :board, :player

end
