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
			it 'prevents a piece from going over another piece' do
				expect {myboard.move('White',Bishop,'a3')}.to raise_error("White Bishop on f1 cannot move to a3")

			end

		end

	end
	describe '#move' do

		it 'allows legal moves' do
			expect(myboard.move('White', Pawn ,'e4')).to be_truthy
			expect(myboard.move('Black', Pawn,'e5')).to be_truthy
			expect(myboard.move('White',Bishop,'c4')).to be_truthy
			expect(myboard.move('Black', Queen,'g5')).to be_truthy
			expect(myboard.move('White',Knight,'f3')).to be_truthy
			expect(myboard.move('Black', Queen,'g6')).to be_truthy
			expect(myboard.move('White',Knight,'e5')).to be_truthy
			expect(myboard.move('Black', Knight,'c6')).to be_truthy
			expect(myboard.move('White',Knight,'g6')).to be_truthy
			expect(myboard.move('Black', Pawn,'b5')).to be_truthy
			expect(myboard.move('White',Knight,'h8')).to be_truthy
			expect(myboard.move('Black', Bishop,'b7')).to be_truthy
			expect(myboard.move('White',Knight,'f7')).to be_truthy
			expect(myboard.move('Black', Knight,'d8')).to be_truthy
			expect(myboard.move('White',Knight,'h6')).to be_truthy
			expect(myboard.move('Black', King,'e7')).to be_truthy
			expect(myboard.move('White',Knight,'f5')).to be_truthy
		
			
		end
	end

	describe 'game_play' do
		let(:black_queen) do
			myboard.piece('d8')
		end

		before do

			myboard.move('White', Pawn ,'e4')
			myboard.move('Black', Pawn,'e5')
			myboard.move('White',Bishop,'c4')
			myboard.move('Black', Queen,'g5')
			myboard.move('White',Knight,'f3')
			myboard.move('Black', Queen,'g6')
			myboard.move('White',Knight,'e5')
		
			myboard.move('Black', Knight,'c6')
			myboard.move('White',Knight,'g6')
			myboard.move('Black', Pawn,'b5')
			myboard.move('White',Knight,'h8')
			myboard.move('Black', Bishop,'b7')
			myboard.move('White',Knight,'f7')
			myboard.move('Black', Knight,'d8')
			myboard.move('White',Knight,'g5')
			myboard.move('Black', Bishop,'e4')
			myboard.move('White',Queen,'h5')
			myboard.move('Black', Knight,'f7')
			myboard.move('White',Queen,'f7')
			myboard.move('Black', King,'d8')
			myboard.move('White',Queen,'f8')
		

		end

		it 'knows how many pieces have been killed' do
			
			expect(myboard.black_killed_pieces.length).to eql(6)
			

		end

		it 'knows which pieces have been killed' do
			
			#expect(myboard.black_killed_pieces).to include(black_queen)

			
		end



		it 'prevents a piece from moving if it will place the king under check' do
			expect {myboard.move('Black',King,'e8')}.to raise_error("Black King on e8 is under attack by White Queen on f8")
		end


	
		it 'knows a checkmate condition' do
			#expect(myboard.checkmate?('black')).to be_truthy
			#expect(myboard.checkmate?('white')).to be_falsey
		end
	end
end



