require 'chess_board.rb'
require 'chess_pieces.rb'
describe 'chess_pieces' do
	context 'when placed on the board' do
		it 'tells which tiles it is attacking'
		it 'tells which tiles it can move to'
		it 'can tell its current tile'

	end

end

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
		it 'knows where every piece on the board is attacking'
		it 'knows which piece has been killed' do
			expect(myboard.taken_pieces).to be 
			expect(myboard.taken_pieces.length).to eql(0)

		end
	end
end


