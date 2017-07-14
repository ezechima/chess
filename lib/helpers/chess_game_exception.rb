module ChimaChess
	class ChessGameException < Exception
	end

	class ChessCheckMateException < ChessGameException
	end
end
