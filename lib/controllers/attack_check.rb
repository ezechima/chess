module ChimaChess
  require './lib/models/attack_pieces.rb'
  class KingChecker
    def self.check(board)
      king_loc = board.king_loc(board.turn_to_play)
      begin
        ChimaChess::AttackCheck.check(
          board: board,
          color: board.turn_to_play,
          tiles: king_loc
        )
      rescue ChimaChess::ChessGameException => exc
        raise ChimaChess::ChessGameException.new("King on #{exc.message}")

      end

    end
  end
  class AttackModelCreator
    def self.create(board)
      attack_list = ChimaChess::AttackList.new
      attack_list.update_attacked_tiles(board)
      attack_list
    end
  end
  class AttackCheck
    def self.check(board:, color:, tiles:)
      attack_list = create_attack_model(board)
      tiles_attacked_by_enemy = filter_enemy_tiles(attack_list,color)
      check_tiles(tiles: tiles, enemy_tiles: tiles_attacked_by_enemy)
      false
    end

    def self.create_attack_model(board)
      attack_list =ChimaChess::AttackModelCreator.create(board)
    end
    def self.filter_enemy_tiles(attack_list,color)
      tiles_attacked = attack_list.tiles_attacked
      tiles_attacked.select {|key, value| !key[color.to_s]}
    end
    def self.check_tiles(tiles:, enemy_tiles:)
      send("check_tiles_in_#{tiles.class}",tiles,enemy_tiles)
    end
    def self.check_tiles_in_String(tile,enemy_tiles)
      enemy_tiles.values.each do |attack_object|

        if attack_object.include?(tile)
          create_attack_exception(attack_object: attack_object, tile: tile)
        end

      end
    end
    def self.check_tiles_in_Array(tiles,enemy_tiles)
      tiles.each {|tile| check_tiles_in_String(tile,enemy_tiles)}
    end
    def self.create_attack_exception(attack_object:, tile:)
      message = "Tile #{tile} is under attack by #{attack_object.attacker_color} #{attack_object.attacker_type} on #{attack_object.attacker_location}"
      raise ChimaChess::ChessGameException.new(message)


    end
  end

end
