require './lib/controllers/chess_application.rb'

describe ChimaChess::ChessApplication do
  let(:myapp) do
    ChimaChess::ChessApplication.new()
  end
  context 'when initialized' do
    it 'has a session controller' do
      expect(myapp.session_controller).to be
    end
    it 'responds to new' do
      expect(myapp.execute_string("new")).to be
    end
  end

  context 'After a new session has been created' do
    before do
      myapp.execute_string('new')
    end
    it 'has a current state' do
      expect(myapp.current_state).to be
    end
    it 'current state is a well pieced chess board' do
      expect(myapp.current_state.piece('a1').piece_type).to eql(:Rook)
      expect(myapp.current_state.piece('h8').piece_type).to eql(:Rook)
      expect(myapp.current_state.piece('e1').piece_type).to eql(:King)
    end

    it 'responds to move calls' do
      expect(myapp.execute_string('b3')).to be
      expect(myapp.execute_string('Nc6').turn_to_play).to eql(:white)
      expect {myapp.execute_string('0-0-0')}.to raise_error(ChimaChess::ChessGameException)
    end
  end


end
