class SessionManager
	attr_accessor :active_session
	def initialize (session_writer:, session_reader:,session_creator:)
	end

	def new_session
		active_session = session_creator.create
	end

	def load_session
		active_session = session_creator.load
	end

	def save_session
		session_writer.write(active_session)
	end


end