module ChimaChess
  require 'yaml'
  class SessionFileIO
    SAVE_DIRECTORY = 'saved_games'
    def self.load(reference:, directory: SAVE_DIRECTORY)
      object = YAML::load(File.read(File.join(directory,reference)))
      object
    end

    def self.save(object:, reference:, directory: SAVE_DIRECTORY)

      file_name = parse_file_name(reference: reference, directory: directory)
      File.open(file_name,"w") {|file| file.puts(YAML::dump(object))}
      true
    end

    def self.list_files(directory: SAVE_DIRECTORY)
      Dir.mkdir("saved_games") unless Dir.exists? directory
      saved_files = Dir.entries(directory).select {|item|  item.to_s[-4,4] == "ches"}
      saved_files
    end

    def self.parse_file_name(reference:, directory:)
      reference[-5,5] == ".ches" ? File.join(directory,reference) : File.join(directory,"#{reference}.ches")
    end
  end

  class SessionDBIO
    def self.load(reference:)

    end

    def self.save(object:, reference:)

    end

    def self.list_files

    end
  end
end
