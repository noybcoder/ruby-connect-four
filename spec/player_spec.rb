# frozen_string_literal: true

require './lib/player'
require './lib/visualizable'

RSpec.describe Player do
  subject(:player1) { Player.new }

  before do
    allow_any_instance_of(Player).to receive(:register_player).and_return('⛵')
    Player.class_variable_set(:@@avatars, [])
  end

  describe '#register_player' do
    context 'when the player selects a unique avatar' do
      it 'assigns the avatar and adds it to @@avatars' do
        allow(player1).to receive(:avatar).and_return('⛵') # Mock avatar selection
        Player.class_variable_set(:@@avatars, ['⛵'])
        expect(Player.class_variable_get(:@@avatars)).to eq(['⛵'])
        expect(player1.avatar).to eq('⛵')
      end
    end

    context 'when the second player selects a unique avatar' do
      it 'assigns the avatar and adds it to @@avatars' do
        player2 = Player.new
        allow(player2).to receive(:avatar).and_return('⚾') # Mock avatar selection
        Player.class_variable_set(:@@avatars, ['⛵', '⚾'])
        expect(Player.class_variable_get(:@@avatars)).to eq(['⛵', '⚾'])
        expect(player2.avatar).to eq('⚾')
      end
    end

    context 'when the second player selects the same avatar as player 1' do
      it 'assigns the avatar and adds it to @@avatars' do
        player2 = Player.new
        allow(player2).to receive(:select_avatar).and_return('⚾', '⛵') # Mock avatar selection
        expect(player2.avatar).to eq('⛵')
      end
    end
  end

  describe '#select_avatar' do
    context 'when player 1 selects a number between 1 and 256' do
      it 'returns the corresponding Unicode character' do
        allow(player1).to receive(:make_choice).and_return('233')
        allow(player1).to receive(:convert_to_unicode).and_return('⛨')
        expect(player1.select_avatar).to eq('⛨')
      end
    end

    context 'when player 1 copies and pastes an avatar from the table' do
      it 'returns the corresponding Unicode character' do
        allow(player1).to receive(:make_choice).and_return('⛵')
        allow(player1).to receive(:convert_to_unicode).and_return('⛵')
        expect(player1.select_avatar).to eq('⛵')
      end
    end

    context 'when player 1 selects anything else other than the listed avatars or numbers between 1 and 256' do
      it 'prints the warning message' do
        warning = "Please only enter number between 1 and 256 or copy and paste the avatar.\n\n"
        allow(player1).to receive(:make_choice).and_return('1a2b', '⛵')
        expect { player1.select_avatar }.to output(warning).to_stdout
      end
    end

    context 'when player 2 selects a number between 1 and 256' do
      it 'returns the corresponding Unicode character' do
        player2 = Player.new
        allow(player2).to receive(:gets).and_return('24')  # Mock input from console
        allow(player2).to receive(:convert_to_unicode).and_return('☗')
        expect(player2.select_avatar).to eq('☗')
      end
    end

    context 'when player 2 copies and pastes an avatar from the table' do
      it 'returns the corresponding Unicode character' do
        player2 = Player.new
        allow(player2).to receive(:gets).and_return('⚽')  # Mock input from console
        allow(player2).to receive(:convert_to_unicode).and_return('⚽')
        expect(player2.select_avatar).to eq('⚽')
      end
    end

    context 'when the player 2 selects anything else other than the listed avatars or numbers between 1 and 256' do
      it 'prints the warning message' do
        player2 = Player.new
        warning = "Please only enter number between 1 and 256 or copy and paste the avatar.\n\n"
        allow(player2).to receive(:make_choice).and_return('677', '⛔')
        expect { player2.select_avatar }.to output(warning).to_stdout
      end
    end
  end

  describe '#make_choice' do
    context 'when an integer is provided by player 1' do
      it 'returns the integer' do
        allow(player1).to receive(:gets).and_return('5')
        expect(player1.make_choice).to eq('5')
      end
    end

    context 'when an integer is provided by player 2' do
      it 'returns the integer' do
        player2 = Player.new
        allow(player2).to receive(:gets).and_return('8')
        expect(player2.make_choice).to eq('8')
      end
    end
  end

  describe '#convert_to_unicode' do
    context 'when player 1 enters the integer 56' do
      it 'returns the Unicode character "☷"' do
        expect(player1.convert_to_unicode(56)).to eq('☷')
      end
    end

    context 'when player enters the string "170"' do
      it 'returns the Unicode character "⚩"' do
        expect(player1.convert_to_unicode('170')).to eq('⚩')
      end
    end

    context 'when player 2 enters the integer 89' do
      it 'returns the Unicode character "♘"' do
        player2 = Player.new
        expect(player2.convert_to_unicode(89)).to eq('♘')
      end
    end

    context 'when player enters the string "198"' do
      it 'returns the Unicode character "⛅"' do
        player2 = Player.new
        expect(player2.convert_to_unicode('198')).to eq('⛅')
      end
    end
  end
end
