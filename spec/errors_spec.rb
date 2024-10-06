require './lib/errors'

RSpec.describe CustomErrors do
  include CustomErrors

  describe '#handle_game_violations' do
    subject(:player_limit_violations) { CustomErrors::PlayerLimitViolation }

    context 'when the number of players is less than the limit' do
      it 'does not raise an error' do
        expect{ handle_game_violations(player_limit_violations, 1, 2) }.not_to raise_error
      end
    end

    context 'when the number of players is same as the limit' do
      it 'does not raise an error' do
        expect{ handle_game_violations(player_limit_violations, 2, 2) }.not_to raise_error
      end
    end

    context 'when the number of players exceeds the limit' do
      it 'raises an error' do
        expect{ handle_game_violations(player_limit_violations, 3, 2) }
          .to raise_error(player_limit_violations, 'Connect Four only allows up to 2 players.')
      end
    end

    subject(:board_limit_violations) { CustomErrors::BoardLimitViolation }

    context 'when the number of boards is same as the limit' do
      it 'does not raise an error' do
        expect{ handle_game_violations(board_limit_violations, 1, 1) }.not_to raise_error
      end
    end

    context 'when the number of boards exceeds the limit' do
      it 'raises an error' do
        expect{ handle_game_violations(board_limit_violations, 2, 1) }
          .to raise_error(board_limit_violations, 'Connect Four only allows 1 board.')
      end
    end
  end

end
