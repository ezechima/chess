
module Save_Load
	require 'yaml'
	def save_game(game)
		system("clear") || system("cls")
		puts "The game is #{game}"
		Dir.mkdir("saved_games") unless Dir.exists? 'saved_games'
		puts "Saved Games"
		list_saved_games('saved_games')
		print "Enter the name of the game "
		name = gets.chomp
		filename = File.join("saved_games","#{name}.ches")
		File.open(filename,"w") {|file| file.puts(YAML::dump(game))}
	end
	def list_saved_games (directory)
		saved_files = Dir.entries(directory).select {|item|  item.to_s[-4,4] == "ches"}
		saved_files.each_index {|index| puts "#{index}:\t#{saved_files[index]}"}
		return saved_files
		
	end
	def load_game
		puts "select the number you would like to load?"
		saved_files = listsavedgames('saved_games')
		response = gets.chomp.to_i
		game = YAML::load(File.read(File.join('saved_games',saved_files[response].to_s)))

		return game
	end
end