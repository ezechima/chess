module ChimaChess
	require './lib/helpers/chess_game_exception.rb'
	require './lib/controllers/attack_check.rb'
	class PieceTypePicker

		def self.pick_piece(piece_hash, piece_type)
			list = piece_hash.select{|piece_name,value| piece_name[piece_type.to_s]}
			check_list(list,piece_type)
			list
		end

		def self.check_list(list,piece_type)
			if list.length == 0
				create_exception("#{piece_type.capitalize} is not in play")
			end
		end

		def self.create_exception(message)
			raise ChimaChess::ChessGameException.new(message)
		end

		def self.get_type_loc(piece_hash)
			attack_object = piece_hash.values.first
			piece_type = "#{attack_object.attacker_color.capitalize} #{attack_object.attacker_type}"
			piece_location = attack_object.attacker_location
			{:piece_type => piece_type, :piece_location => piece_location,
				:file => piece_location[0], :rank => piece_location[1]}
		end
	end

	class DestinationPicker < PieceTypePicker

		def self.pick_destination(piece_hash, destination_str)
			list = piece_hash.select{|key,value| value.include?(destination_str.to_s)}
			check_list(list,destination_str,piece_hash)
			list
		end

		def self.check_list(list,destination_str,initial_list)
			if list.length == 0
				process_error(initial_list,destination_str)
			end
		end

		def self.process_error(list,destination_str)
			params = get_type_loc(list)
			message = "#{params[:piece_type]} on #{params[:piece_location]} cannot move to #{destination_str} "
			create_exception(message)
		end
	end

	class FileRankPicker < PieceTypePicker

		def self.pick(destination_list:,**file_rank)
			list = destination_list
 			list = check(list,file_rank[:file],:file,destination_list) if file_rank[:file]
			list = check(list, file_rank[:rank],:rank, destination_list) if file_rank[:rank]
			list
		end

		def self.check(list,file_rank,sym_file_rank, initial_list)
			list = list.select {|key,value| value.attacker_location[file_rank]}
			if list.length == 0
				process_error(initial_list,file_rank,sym_file_rank)
			end
			list
		end

		def self.process_error(list,file_rank,sym_file_rank)
			params = get_type_loc(list)
			message = "#{params[:piece_type].capitalize} is on #{sym_file_rank} #{params[sym_file_rank]} not on #{sym_file_rank} #{file_rank}"
			create_exception(message)
		end
	end

	class FindPiece
		#check if piece type exists
		#check if piece destination exists
		#if file is specified check if piece on file can move to destination
		#if rank is specified, check if piece on rank can move to destination
		def self.find (board:,color:,type:,destination_str:, **file_rank)
			attack_list = create_attack_model(board)
			colored_list = find_color(color,attack_list)
			type_list = ChimaChess::PieceTypePicker.pick_piece(colored_list,type)
			destination_list = ChimaChess::DestinationPicker.pick_destination(type_list,destination_str)
			found_hash = ChimaChess::FileRankPicker.pick(destination_list: destination_list, **file_rank)
			process_not_specific_request(found_hash,destination_str,board) if found_hash.length > 1
			return found_hash
		end

		def self.find_color(color, attack_list)
			tiles_attacked = attack_list.tiles_attacked
			tiles_attacked.select {|key,value| key[color.to_s]}
		end

		def self.create_attack_model(board)
			attack_list = ChimaChess::AttackModelCreator.create(board)
		end

		def self.process_not_specific_request(found_hash,destination_str,board)
			message = "#{found_hash.keys.join(" & ")} can move to #{destination_str}, please specify a file or rank"
			raise ChimaChess::ChessGameException.new(message)
		end
	end
end
