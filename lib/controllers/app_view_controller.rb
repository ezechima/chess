module ChimaChess
  require './lib/views/initial_dialog.rb'
  require './lib/views/input_receiver.rb'
  require './lib/views/render_board.rb'
  require './lib/views/render_player.rb'
  require './lib/views/render_status.rb'

  class AppViewController
    attr_accessor :application, :players
    def initialize(application)
      @application = application
      @players = {white: 'White', black: 'Black'}
    end

    def start
      render_initial_dialog
      while (true) do
        get_input()
        clear_screen
        render_application
      end


    end
    def render_initial_dialog
      ChimaChess::InitialDialog.render
    end
    def get_input(context=nil)
      context = context || @application
      ChimaChess::InputReceiver.get_input(executor: context)
    end
    def clear_screen
      system('clear') || system('cls')
    end
    def render_application
      render_board
      render_status
      render_player
      true
    end
    def render_board
      ChimaChess::RenderBoard.render(board: @application.current_state)
      true
    end
    def render_status
      ChimaChess::RenderStatus.render(@application.current_status)
      true
    end
    def render_player
      ChimaChess::RenderPlayer.render(board: @application.current_state,players: @players)
      true
    end
  end
end
