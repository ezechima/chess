module ChimaChess
  require './lib/models/attack_pieces.rb'

  class CheckmateChecker

    def self.create_attack_model(board)
      attack_list =ChimaChess::AttackModelCreator.create(board)
    end

    def self.filter_team_tiles(attack_list,color)
      tiles_attacked = attack_list.tiles_attacked
      tiles_attacked.select {|key, value| key[color.to_s]}
    end

    def self.create_message_object(attack_object,attack_tile)
      src_rank = attack_object.attacker_location[1]
      src_file = attack_object.attacker_location[0]
      ChimaChess::MoveExprProcessor.create_message(attack_object.attacker_type,attack_tile,src_rank,src_file)
    end

    def self.execute_move(message, board)
      ChimaChess::MoveController.process(message: message, state: board)
    end

    def self.iterate_over_moves(team_list,board)
      move_failed = true
      team_list.each do |attack_object|
        attack_object.list_of_tiles.each do |attack_tile|
            begin
              move_failed = false
              temp_board = ObjectDuplicator.duplicate(board)
              move_message = create_message_object(attack_object,attack_tile)
              execute_move(move_message,temp_board)
            rescue ChimaChess::ChessGameException => e
              move_failed = true
            end
          return move_failed if move_failed == false
          end
        end
      move_failed
    end

    def self.checkmate?(board)
      attack_hash = create_attack_model(board)
      team_hash = filter_team_tiles(attack_hash, board.turn_to_play)
      iterate_over_moves(team_hash.values,board)
    end
  end

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

    def self.checkmate?(board)
      begin
				check(board)
			rescue ChimaChess::ChessGameException => e
				ChimaChess::CheckmateChecker.checkmate?(board) ? raise_checkmate_exception(e,board) : raise_check_exception(e,board)
			end
    end

    def self.raise_check_exception (exception, board)
      message = "Check! #{board.turn_to_play} #{exception.message}"
      raise ChimaChess::ChessGameException.new(message)
    end

    def self.raise_checkmate_exception (exception, board)
      message = "Checkmate! #{board.turn_to_play.capitalize} Loses"
      raise ChimaChess::ChessCheckMateException.new(message)
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
