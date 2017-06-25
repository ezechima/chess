module ChimaChess
  require './lib/controllers/place_chess_pieces.rb'
  require './lib/models/chess_board.rb'

  class BoardCreator
    def self.create(config: "standard")
      board = create_board
      pieced_board = place_pieces(board: board, config: config)

    end
    def create_board
      ChimaChess::ChessBoard.new

    end
    def place_pieces(board:, config:)
      ChimaChess::PlaceChessPieces.new.place_chess_pieces(config: config, board: board)

    end
  end
end
