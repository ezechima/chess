
load 'lib/models/chess_board.rb'
load 'lib/models/chess_pieces.rb'
load 'lib/models/attack_pieces.rb'
load 'lib/controllers/place_chess_pieces.rb'
load 'lib/controllers/find_piece.rb'
load 'lib/controllers/attack_check.rb'
load 'lib/controllers/chess_input_controllers.rb'
load 'lib/controllers/castle_check.rb'
load 'lib/views/render_board.rb'

@my_board = ChimaChess::ChessBoard.new
@my_tile = @my_board.tile('d5')
@tile_e5 = @my_board.tile('e5')
@tile_h5 = @my_board.tile('h5')
@tile_g5 = @my_board.tile('g5')
@black_king = ChimaChess::King.new(color: :black,first_location: "d5")
@black_queen = ChimaChess::Queen.new(color: :black,first_location: "d5")
@black_rook = ChimaChess::Rook.new(color: :black,first_location: "d5")
@black_bishop = ChimaChess::Bishop.new(color: :black,first_location: "d5")
@black_knight = ChimaChess::Knight.new(color: :black,first_location: "d5")
@black_pawn = ChimaChess::Pawn.new(color: :black,first_location: "d5")
@white_pawn = ChimaChess::Pawn.new(color: :white,first_location: "d5")
@white_rook = ChimaChess::Rook.new(color: :white,first_location: "d5")
@my_attack_list = ChimaChess::AttackList.new

@my_tile.piece = @black_queen
@tile_g5.piece = @white_rook
@my_board2 = ChimaChess::PlaceChessPieces.new.place_chess_pieces(config: "test", board: @my_board)
@my_attack_list.update_attacked_tiles(@my_board2)

puts "Tiles Attacked by Black"
@my_attack_list.tiles_attacked_by_black.each do |keys, value|
	puts "\tKey Value is: #{keys}"
	puts "\t\tAttacker Class is: #{value.attacker_type}"
	puts "\t\tAttacker location is: #{value.attacker_location}"
	puts "\t\tTiles attacked: #{value.list_of_tiles.sort}"
	#puts "\t\texpect(attack_list['#{keys}'].sort).to eql(#{value.list_of_tiles.sort})"
	puts "\n"
end

puts "Tiles Attacked by White"
@my_attack_list.tiles_attacked_by_white.each do |keys, value|
	puts "\tKey Value is: #{keys}"
	puts "\t\tAttacker Class is: #{value.attacker_type}"
	puts "\t\tAttacker location is: #{value.attacker_location}"
	puts "\t\tTiles attacked: #{value.list_of_tiles.sort}"
	#puts "\t\texpect(attack_list['#{keys}'].sort).to eql(#{value.list_of_tiles.sort})"
	puts "\n"
end
puts "Testing Find Piece"
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Knight,destination_str: "e5")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Pawn,destination_str: "a4")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Rook,destination_str: "b3")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Knight,destination_str: "a6")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Bishop,destination_str: "f7")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Queen,destination_str: "b3")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :white, type: :Bishop,destination_str: "e5")
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :black, type: :Bishop,destination_str: "e3", file: "c", rank: '5')
	puts ChimaChess::FindPiece.find(board: @my_board2,color: :black, type: :Queen,destination_str: "e5", file: "d", rank: '6')

puts "Testing Attack Check"
	puts ChimaChess::AttackCheck.check(board: @my_board2, color: :white, tiles: ['a1','a2'])
	puts ChimaChess::AttackCheck.check(board: @my_board2, color: :white, tiles: 'b5')

puts "Testing Castle Check"
	#puts ChimaChess::CastleCheck.check(board: @my_board2, color: :white, side: :queen_side)
puts 'Testing Input Controller'
	puts ChimaChess::ChessTextProcessor.process_input("New")

	puts ChimaChess::ChessTextProcessor.process_input("LOAD")
	puts ChimaChess::ChessTextProcessor.process_input("save")
	puts ChimaChess::ChessTextProcessor.process_input("eXit")
	puts ChimaChess::ChessTextProcessor.process_input("undo")
	puts ChimaChess::ChessTextProcessor.process_input("redo")
	puts ChimaChess::ChessTextProcessor.process_input("b4").inspect
	puts ChimaChess::ChessTextProcessor.process_input("3c7").inspect
	puts ChimaChess::ChessTextProcessor.process_input("a4d8").inspect
	puts ChimaChess::ChessTextProcessor.process_input("Nb4").inspect
	puts ChimaChess::ChessTextProcessor.process_input("K3c7").inspect
	puts ChimaChess::ChessTextProcessor.process_input("Ba4d8").inspect
	puts ChimaChess::ChessTextProcessor.process_input("Kb4").inspect
	puts ChimaChess::ChessTextProcessor.process_input("Q3c7").inspect
	puts ChimaChess::ChessTextProcessor.process_input("Bf4h8").inspect
	puts ChimaChess::ChessTextProcessor.process_input("0-0").inspect
	puts ChimaChess::ChessTextProcessor.process_input("O-O-O").inspect
	puts ChimaChess::ChessTextProcessor.process_input("O-O").inspect
	puts
puts "Rendering Board"
	ChimaChess::RenderBoard.render(board: @my_board2)

puts "Knowing king Location"
	puts @my_board2.king_loc(:black)
	puts @my_board2.king_loc(:white)
