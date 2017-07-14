module ChimaChess
  class InitialDialog
    def self.render
      puts "Welcome, What will you like to do?"
      puts "New: New game"
      puts "Load: Load existing Game"
      puts "Exit: Gerrout"
    end
  end
  class ContinueDialog
    def self.render
      puts "What will you like to do next?"
      puts "New, Load or Exit"
    end
  end
end
