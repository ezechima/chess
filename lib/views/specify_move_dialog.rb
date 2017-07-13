module ChimaChess
  class SpecifyMoveDialog
    def self.render (params)
      puts "Input the number of the piece you would like to move:"
      params.each_index{|index| puts "#{index}: #{params[index]}" }
      piece_number = gets.chomp
      params[piece_number.to_i]
    end
  end
end
