module ChimaChess
  require './lib/controllers/chess_session_controller.rb'
  require './lib/controllers/chess_input_controllers.rb'
  class ChessApplication
    attr_reader :session_controller

    def initialize
        @session_controller = create_session_controller
    end

    def create_session_controller
     ChimaChess::ChessSessionController.new(self)
    end

    def execute_string(input_string)
      message = interpret_string(input_string)
      session_controller.process(message)
    end

    def current_state
      session_controller.current_state
    end
    def interpret_string(input_string)
      ChimaChess::ChessTextProcessor.process_input(input_string)
    end
    def exit
      exit(true)
    end
  end
end
