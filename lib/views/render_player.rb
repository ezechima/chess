module ChimaChess
  class RenderPlayer
    def self.render(board:,players:)
      turn_to_play = board.turn_to_play
      player = players[turn_to_play] || turn_to_play
      render_information(player)
    end
    def self.render_information(player)
        puts "#{player.to_s.capitalize}, what's your move? "
    end
  end
end
