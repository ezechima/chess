require 'lib/helpers/point.rb'

describe Point do
	let (:mypoint) do
		ChimaChess::Point.new(1,2,3)
	end

	context 'when initialized' do 
		it 'initializes from arrays' do

			expect(ChimaChess::Point.new([1,2,3]).to eql(mypoint)

		end
		it 'initializes from Strings'
		it 'initializes from Symbols'
		it 'initializes from Points' do
			expect(ChimaChess::Point.new(mypoint).to eql(mypoint)
		end
		

	end

end



