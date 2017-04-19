
	def execs(myboard)
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
def special_game(myboard)
			myboard.move('White', Pawn ,'d4')
			myboard.move('Black', Knight,'f6')
			myboard.move('White',Pawn,'c4')
			myboard.move('Black', Pawn,'e6')
			myboard.move('White',Knight,'c3')
			myboard.move('Black', Bishop,'b4')
			myboard.move('White',Queen,'c2')
		
			myboard.move('Black', Pawn,'d5')
			myboard.move('White',Pawn,'a3')
			myboard.move('Black', Bishop,'e7')


			myboard.move('White',Pawn,'d5')
			myboard.move('Black', Pawn,'d5')
			myboard.move('White',Bishop,'f4')
			myboard.move('Black', Pawn,'c6')
			myboard.move('White',Knight,'h3')
			myboard.castle('Black','rook_east')




=begin
			myboard.move('Black', Bishop,'e4')
			myboard.move('White',Queen,'h5')
			myboard.move('Black', Knight,'f7')
			myboard.move('White',Queen,'f7')
			myboard.move('Black', King,'d8')
			myboard.move('White',Queen,'f8')
=end	
end
