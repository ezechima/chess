require './lib/models/chess_board.rb'
require './lib/controllers/place_chess_pieces.rb'
require './lib/models/attack_pieces.rb'

describe ChimaChess::AttackList do
	let (:myboard) do
		ChimaChess::PlaceChessPieces.new().place_chess_pieces(board: ChimaChess::ChessBoard.new, config: "test")
	end
	let (:attack_list) do
		attack_list = ChimaChess::AttackList.new
		attack_list.update_attacked_tiles(myboard)
		attack_list.simple_list
	end


	context 'when initialized with a test configuration' do 

		it 'has correct Pawn attack configuration' do
			expect(attack_list['black Pawn a7'].sort).to eql(["a5"])
			expect(attack_list['black Pawn b7'].sort).to eql(["b6"])
            expect(attack_list['black Pawn c7'].sort).to eql(["c6"])
            expect(attack_list['black Pawn d7'].sort).to eql(["d5"])
            expect(attack_list['black Pawn e7'].sort).to eql(["e5", "e6"])
            expect(attack_list['black Pawn f7'].sort).to eql(["f6"])
            expect(attack_list['black Pawn g7'].sort).to eql(["g6"])
            expect(attack_list['black Pawn h7'].sort).to eql(["h5"])
            expect(attack_list['white Pawn a2'].sort).to eql(["a4"])
            expect(attack_list['white Pawn b2'].sort).to eql(["b3"])
            expect(attack_list['white Pawn c2'].sort).to eql(["c3"])
            expect(attack_list['white Pawn d2'].sort).to eql(["d4"])
            expect(attack_list['white Pawn e2'].sort).to eql(["e3", "e4"])
            expect(attack_list['white Pawn f2'].sort).to eql(["f3"])
            expect(attack_list['white Pawn g2'].sort).to eql(["g3"])
            expect(attack_list['white Pawn h2'].sort).to eql(["h4"])
		end

		it 'has correct Rook attack configuration' do
			expect(attack_list['black Rook a6'].sort).to eql(["a3", "a4", "a5", "b6", "c6"])
            expect(attack_list['black Rook h6'].sort).to eql(["e6", "f6", "g6", "h3", "h4", "h5"])
            expect(attack_list['white Rook a3'].sort).to eql(["a4", "a5", "a6", "b3", "c3"])
            expect(attack_list['white Rook h3'].sort).to eql(["e3", "f3", "g3", "h4", "h5", "h6"])
		end

		it 'has correct Knight attack configuratio' do
	        expect(attack_list['black Knight b5'].sort).to eql(["a3", "c3", "d4"])
	        expect(attack_list['black Knight g5'].sort).to eql(["e4", "e6", "f3", "h3"])
	        expect(attack_list['white Knight b4'].sort).to eql(["a6", "c6", "d5"])
	        expect(attack_list['white Knight g4'].sort).to eql(["e3", "e5", "f6", "h6"])
		end

		it 'has correct Bishop attack configuration' do
            expect(attack_list['black Bishop c5'].sort).to eql(["b4", "b6", "d4", "e3", "f2"])
            expect(attack_list['black Bishop f5'].sort).to eql(["d3", "e4", "e6", "g4", "g6"])
            expect(attack_list['white Bishop c4'].sort).to eql(["b3", "b5", "d5", "e6", "f7"])
            expect(attack_list['white Bishop f4'].sort).to eql(["d6", "e3", "e5", "g3", "g5"])
        end

		it 'has correct Queen attack configuration' do
            expect(attack_list['black Queen d6'].sort).to eql(["b6", "c6", "d3", "d4", "d5", "e5", "e6", "f4", "f6", "g6"])
            expect(attack_list['white Queen d3'].sort).to eql(["b3", "c3", "d4", "d5", "d6", "e3", "e4", "f3", "f5", "g3"])
		end

		it 'has correct King attack configuration' do
                expect(attack_list['black King e8'].sort).to eql(["d8", "f8"])
                expect(attack_list['white King e1'].sort).to eql(["d1", "f1"])
        end
	end
end



