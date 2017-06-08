load 'lib/models/chess_board.rb'
load 'lib/models/chess_pieces.rb'
load 'lib/models/attack_pieces.rb'
load 'lib/controllers/place_chess_pieces.rb'

@my_board = ChimaChess::ChessBoard.new
@my_tile = @my_board.tile('d5')
@tile_e5 = @my_board.tile('e5')
@tile_h5 = @my_board.tile('h5')
@tile_g5 = @my_board.tile('g5')
@black_king = ChimaChess::King.new(:black,"d5")
@black_queen = ChimaChess::Queen.new(:black,"d5")
@black_rook = ChimaChess::Rook.new(:black,"d5")
@black_bishop = ChimaChess::Bishop.new(:black,"d5")
@black_knight = ChimaChess::Knight.new(:black,"d5")
@black_pawn = ChimaChess::Pawn.new(:black,"d5")
@white_pawn = ChimaChess::Pawn.new(:white,"d5")
@white_rook = ChimaChess::Rook.new(:white,"d5")
@my_attack_list = ChimaChess::AttackList.new

@my_tile.piece = @black_queen
@tile_g5.piece = @white_rook
@my_attack_list.update_attacked_tiles(@my_board)

puts "Tiles Attacked by Black"
@my_attack_list.tiles_attacked_by_black.each do |keys, value|
	puts "\tKey Value is: #{keys}"
	puts "\t\tAttacker Class is: #{value.attacker_class}"
	puts "\t\tAttacker location is: #{value.attacker_location}"
	puts "\t\tTiles attacked: #{value.list_of_tiles.sort}"
	puts "\n"
end

puts "Tiles Attacked by White"
@my_attack_list.tiles_attacked_by_white.each do |keys, value|
	puts "\tKey Value is: #{keys}"
	puts "\t\tAttacker Class is: #{value.attacker_class}"
	puts "\t\tAttacker location is: #{value.attacker_location}"
	puts "\t\tTiles attacked: #{value.list_of_tiles.sort}"
	puts "\n"
end



