require './lib/controllers/place_chess_pieces.rb'

describe ChimaChess::PlaceChessPieces do
	let (:myboard) do
		ChimaChess::ChessBoard.new
	end
	let (:placer) do
		ChimaChess::PlaceChessPieces.new
	end
	let (:placed_board) do
		placer.place_chess_pieces(myboard)
	end
	let (:piece_count) do
		count=0
		black_piece=0
		white_piece=0
		placed_board.each_piece do |piece,point| 
			count = count + 1 
			black_piece = black_piece + 1 if piece.color == :black
			white_piece = white_piece + 1 if piece.color == :white
		end


		[count,black_piece,white_piece]
	end


	context 'after placement' do 
		it 'has 32 pieces' do
			expect(piece_count[0]).to eql(32)

		end
		it 'has 16 black pieces' do
			expect(piece_count[1]).to eql(16)

		end

		it 'has 16 white pieces' do
			expect(piece_count[2]).to eql(16)

		end

		it 'pieces are properly positined' do
			expect(placed_board.tile(:a1).piece.name).to eql("white ChimaChess::Rook a1")
			expect(placed_board.tile(:a2).piece.name).to eql("white ChimaChess::Pawn a2")
			expect(placed_board.tile(:h2).piece.name).to eql("white ChimaChess::Pawn h2")
			expect(placed_board.tile(:a8).piece.name).to eql("black ChimaChess::Rook a8")
			expect(placed_board.tile(:h7).piece.name).to eql("black ChimaChess::Pawn h7")
			expect(placed_board.tile(:d1).piece.name).to eql("white ChimaChess::Queen d1")
			expect(placed_board.tile(:e1).piece.name).to eql("white ChimaChess::King e1")
			expect(placed_board.tile(:g8).piece.name).to eql("black ChimaChess::Knight g8")
			expect(placed_board.tile(:c8).piece.name).to eql("black ChimaChess::Bishop c8")
			expect(placed_board.tile(:e8).piece.name).to eql("black ChimaChess::King e8")
		end




	end



end



