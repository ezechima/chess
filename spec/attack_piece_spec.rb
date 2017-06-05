require './lib/models/chess_board.rb'
require './lib/controllers/place_chess_pieces.rb'
require './lib/models/attack_pieces.rb'

describe ChimaChess::ChessBoard do
	let (:myboard) do
		ChimaChess::PlaceChessPieces.new().place_chess_pieces(ChimaChess::ChessBoard.new)
	end
	let (:attack_list) do
		attack_list = ChimaChess::AttackTiles.new
		attack_list.update_attack_tiles(myboard)
		attack_list
	end


	context 'when initialized' do 


	end



end



