module ChimaChess
  class LoadDialog
    def self.render(io_manager:)
      files = io_manager.list_files
      puts "Select the number you would like to load"
      files.each_index{|index| puts "#{index}: #{files[index]}" }
      file_number = gets.chomp
      files[file_number.to_i]
    end
  end
  class SaveDialog
    def self.render(io_manager:)
      files = io_manager.list_files
      puts "What would you like to save your game as"
      files.each_index{|index| puts "#{index}: #{files[index]}" }
      file_name = gets.chomp
      file_name.to_s
    end
  end
end
