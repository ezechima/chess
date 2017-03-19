require 'chess_board.rb'
require 'chess_pieces.rb'


describe Chess_Board do
	let (:myboard) do
		Chess_Board.new
	end
	let(:count) do
		index = 0
		myboard.each {|tile| index+=1 if tile.instance_of?(Chess_Tile)}	
		index
		
	end
	context 'when initialized' do 
		it 'has Chess_Tiles' do

			expect(myboard.tile("c3")).to be_an_instance_of(Chess_Tile)
			expect(count).to eql(64)

		end
		it 'chess tiles know their string locations' do
			expect(myboard.tile("c3").str_location).to eql("c3")
			expect(myboard.tile("a1").str_location).to eql("a1")
			expect(myboard.tile("d4").str_location).to eql("d4")
			expect(myboard.tile("e7").str_location).to eql("e7")
			expect(myboard.tile("f8").str_location).to eql("f8")
			expect(myboard.tile("h5").str_location).to eql("h5")
		end
		it 'chess tiles know their point locations' do
			expect(myboard.tile("c3").location).to eql(Point.new(2,2))
			expect(myboard.tile("a1").location).to eql(Point.new(0,0))
			expect(myboard.tile("d4").location).to eql(Point.new(3,3))
			expect(myboard.tile("e7").location).to eql(Point.new(4,6))
			expect(myboard.tile("f8").location).to eql(Point.new(5,7))
			expect(myboard.tile("h5").location).to eql(Point.new(7,4))
		end


	end

	context 'when initialized with chess_pieces' do
		it ' has a record of all pieces on the board,' do
			expect(myboard.active_pieces.length).to eql(32)
		end
		it 'knows all the tiles that are under attack by each team' do
			expect(myboard.white_attack_tiles.keys.length).to eql(8)
		end
		it 'has an easy pointer to the kings' do
			expect(myboard.black_king.name).to eql("Black King e8")
			expect(myboard.white_king.name).to eql("White King e1")

		end

	end

	describe 'chess_pieces' do
		context 'when placed on the board' do
			it 'tells which tiles it is attacking' do
				expect(myboard.piece('a1').attackTiles_list).to eql([])
				expect(myboard.piece('a2').attackTiles_list).to contain_exactly('b3')
				expect(myboard.piece('b1').attackTiles_list).to contain_exactly('a3','c3')
				expect(myboard.piece('c7').attackTiles_list).to contain_exactly('b6','d6')
			end
			it 'tells which tiles it can move to' do
				expect(myboard.piece('a1').moveTiles_list).to eql([])
				expect(myboard.piece('a2').moveTiles_list).to contain_exactly('a3','a4')
				expect(myboard.piece('b1').moveTiles_list).to contain_exactly('a3','c3')
				expect(myboard.piece('c7').moveTiles_list).to contain_exactly('c6','c5')
			end
			


			it 'can tell its current tile' do
				expect(myboard.tile("a1").piece.getTile.str_location).to eql("a1")
				expect(myboard.tile("b2").piece.getTile.str_location).to eql("b2")
				expect(myboard.tile("h7").piece.getTile.str_location).to eql("h7")
				expect(myboard.tile("d2").piece.getTile.str_location).to eql("d2")
				expect(myboard.tile("f8").piece.getTile.str_location).to eql("f8")
			end

		end

	end
	describe '#move' do
		before do
			myboard.kill_piece(myboard.piece('h1'))
		end

		it 'knows which piece has been killed' do
			expect(myboard.piece('h1').name).to eql("White Rook h1")
			expect(myboard.white_killed_pieces).to be 
			expect(myboard.white_killed_pieces.length).to eql(1)
		end

		it 'prevents a piece from moving if it will place the king under check'
		it 'updates the hasmoved? property of a piece'
		it 'prevents a piece from going over another piece'
		it 'kills a competing piece when hit'
		end

	describe '#check' do
		it 'knows a checkmate condition'
	end
end



