module ChimaChess
  class PromoteDialog
    PROMOTE_TYPES = [:Queen,:Rook,:Bishop,:Knight, :Pawn]
    def self.render
      puts "Select the number of the piece you would like to promote to:"
      PROMOTE_TYPES.each_index{|index| puts "#{index}: #{PROMOTE_TYPES[index]}" }
      piece_number = gets.chomp
      PROMOTE_TYPES[piece_number.to_i]  
    end
  end
end
