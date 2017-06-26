module ChimaChess
  class ChessApplication
    attr_reader :session_controller

    def initialize
        @session_controller = create_session_controller
    end

    def create_session_controller(self)
     ChimaChess::ChessSessionController.new(self)
    end

    def current_state
      session_controller.current_state
    end
    
    def exit
      exit(true)
    end
  end
end
