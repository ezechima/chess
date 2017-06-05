require './lib/models/chess_board.rb'

describe ChimaChess::ChessBoard do
	let (:myboard) do
		ChimaChess::ChessBoard.new
	end
	let (:tile_count) do
		count = 0 
		myboard.each_tile {count +=1}
		count
	end


	context 'when initialized' do 
		it 'has 64 tiles' do
			expect(tile_count).to eql(64)

		end
		it 'tiles are properly aligned' do
			expect(myboard.tile(:a1).to_s).to eql("a1")
			expect(myboard.tile(:b2).to_s).to eql("b2")
			expect(myboard.tile(:c3).to_s).to eql("c3")
			expect(myboard.tile(:d4).to_s).to eql("d4")
			expect(myboard.tile(:e5).to_s).to eql("e5")
			expect(myboard.tile(:f6).to_s).to eql("f6")
			expect(myboard.tile(:g7).to_s).to eql("g7")
			expect(myboard.tile(:h8).to_s).to eql("h8")

		end

		it 'returns nil for tiles outside the boundary' do
			expect(myboard.tile([9,9])).to be_nil
			expect(myboard.tile([8,8])).to be_nil
			expect(myboard.tile([7,8])).to be_nil
			expect(myboard.tile([-1,8])).to be_nil
			expect(myboard.tile([-1,0])).to be_nil
			expect(myboard.tile([0,8])).to be_nil
			expect(myboard.tile([0,-1])).to be_nil
		end


	

	end



end



