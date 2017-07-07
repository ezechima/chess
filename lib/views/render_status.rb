module ChimaChess
  class RenderStatus
    def self.render(status)
      render_information(status)
    end
    def self.render_information(status)
        puts "Commands: New, Save, Load, Undo, Redo, Exit"
        puts "Input move commands using Minimal Algebraic Chess Notation"
        status && puts("Info: #{status}")
    end
  end
end
