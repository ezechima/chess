module ChimaChess
  require 'yaml'
  require 'sqlite3'
  SAVE_DIRECTORY = 'saved_games'
  class SessionFileIO

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
      game_db = initialize_db
      data = game_db.get_first_value("SELECT Data FROM GAMES WHERE Name = '#{reference}'")
      close_db(game_db)
      puts data.class
      object = Marshal.load(data)
    end

    def self.save(object:, reference:)
      game_db = initialize_db
      serial_object = Marshal.dump(object)
      data = SQLite3::Blob.new serial_object
      begin
        execute_insert(game_db,data,reference)
      rescue SQLite3::ConstraintException => e
        execute_update(game_db,data,reference)
      ensure
        close_db(game_db)
      end
      true
    end

    def self.execute_insert(db,data,reference)
      begin
        stmt = db.prepare("INSERT INTO GAMES VALUES(?,?)")
        stmt.bind_params(reference,data)
        stmt.execute
      rescue Exception => e
        raise e
      ensure
        stmt.close
      end
    end

    def self.execute_update(db,data,reference)
      stmt = db.prepare("UPDATE GAMES SET Data = ? WHERE NAME = ?")
      stmt.bind_params(data,reference)
      stmt.execute
      stmt.close
    end

    def self.list_files(directory: SAVE_DIRECTORY)
      game_db = initialize_db(directory: directory)
      rs = game_db.execute('SELECT Name FROM GAMES LIMIT 15')
      file_list = []
      rs.each{|list| file_list<<list[0]}
      close_db(game_db)
      file_list
    end

    def self.close_db(db)
      db.close
    end

    def self.initialize_db(directory: SAVE_DIRECTORY)
      db_name = File.join(directory,'game_db.db')
      game_db = SQLite3::Database.open db_name
      initialize_db_table(game_db)
      game_db
    end

    def self.initialize_db_table(db)
      db.execute('CREATE TABLE IF NOT EXISTS GAMES(Name TEXT PRIMARY KEY, Data BLOB)')
    end
  end
end
