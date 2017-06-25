module ChimaChess
  class ChessApplication
    attr_reader :session_controller
    def initialize
        @session_controller = create_session_controller
    end
    def create_session_controller(self)
     ChimaChess::ChessSessionController.new(self)
    end
  end
end
