module ChimaChess
  require './lib/controllers/chess_session_controller.rb'
  require './lib/controllers/chess_input_controllers.rb'
  require './lib/controllers/app_view_controller.rb'
  require './lib/controllers/session_io.rb'
  class ChessApplication
    attr_reader :session_controller, :app_view_controller
    attr_accessor :current_status

    def initialize
        @session_controller = create_session_controller
        @app_view_controller =create_app_view_controller
    end

    def create_session_controller
     ChimaChess::ChessSessionController.new(self)
    end

    def create_app_view_controller
      ChimaChess::AppViewController.new(self)
    end

    def session_IO
      ChimaChess::SessionFileIO
    end

    def start
      app_view_controller.start
    end

    def reset_current_status
      @current_status = nil
    end

    def update_current_status(message)
      @current_status = message
    end

    def execute(message)
      reset_current_status
      begin
        send("execute_#{message.class.to_s.downcase}",message)
      rescue ChimaChess::ChessGameException => e
        update_current_status(e.message)
      end
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

    def exit_application
      exit(true)
    end
  end
end
