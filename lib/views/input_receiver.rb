module ChimaChess
  class InputReceiver
    def self.get_input(executor:,message: nil)
      puts ""
      print message
      instruction = gets.chomp
      executor.execute(instruction)
    end
  end
end
