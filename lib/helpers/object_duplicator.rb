module ChimaChess
  class ObjectDuplicator
    def self.duplicate(object)
      Marshal.load(Marshal.dump(object))  
    end
  end
end
