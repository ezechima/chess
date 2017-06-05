require './lib/helpers/point.rb'

describe ChimaChess::Point do
	let (:mypoint) do
		ChimaChess::Point.new(1,2,3)
	end
	let (:mypoint2) do
		ChimaChess::Point.new(2,3)
	end

	context 'when initialized' do 
		it 'initializes from arrays' do

			expect(ChimaChess::Point.new([1,2,3])).to eql(mypoint)

		end
		it 'initializes from Strings' do
			expect(ChimaChess::Point.new("c4")).to eql(mypoint2)

		end
		it 'initializes from Symbols' do
			expect(ChimaChess::Point.new(:c4)).to eql(mypoint2)
		end
		it 'initializes from Points' do
			expect(ChimaChess::Point.new(mypoint)).to eql(mypoint)
		end
		

	end

	context 'when adding' do
		it 'adds two points' do
			expect(mypoint+mypoint2).to eql(ChimaChess::Point.new([3,5,3]))
		end

		it 'multiplies by a constant' do
			expect(mypoint*3).to eql(ChimaChess::Point.new([3,6,9]))
		end
		
	end

end



