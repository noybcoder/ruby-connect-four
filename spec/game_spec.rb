# frozen_string_literal: true

require './lib/game'

RSpec.describe Game do
  let(:player1) { instance_double(Player, avatar: '⛵', moves: [[0, 0], [0, 1]]) }
  let(:player2) { instance_double(Player, avatar: '⚾', moves: [[0, 3], [1, 2]]) }
  let(:board) { Board.new }
  subject(:game) { Game.new([player1, player2], board) }

  before do
    Board.board_count = 0
  end

  describe '#game_over_notice' do
    context 'when no player is winning and it is not a draw' do
      before do
        allow(game).to receive(:win?).with(player1).and_return(false)
        allow(game).to receive(:win?).with(player2).and_return(false)
        allow(game).to receive(:draw?).and_return(false)
      end

      it 'returns false for both players' do
        expect(game.game_over_notice(player1, 0)).to be(false)
        expect(game.game_over_notice(player2, 1)).to be(false)
      end
    end

    context 'when player 1 is winning' do
      before do
        allow(game).to receive(:win?).with(player1).and_return(true)
        allow(game).to receive(:win?).with(player2).and_return(false)
      end

      it 'returns true for player 1 and puts the winning message while returning false for player 2' do
        expect { game.game_over_notice(player1, 0) }.to output("\nPlayer 1 wins!\n").to_stdout
        expect(game.game_over_notice(player1, 0)).to eq(true)
        expect(game.game_over_notice(player2, 1)).to be(false)
      end
    end

    context 'when player 2 is winning' do
      before do
        allow(game).to receive(:win?).with(player1).and_return(false)
        allow(game).to receive(:win?).with(player2).and_return(true)
      end

      it 'returns true for player 2 and puts the winning message while returning false for player 1' do
        expect(game.game_over_notice(player1, 0)).to eq(false)
        expect { game.game_over_notice(player2, 1) }.to output("\nPlayer 2 wins!\n").to_stdout
        expect(game.game_over_notice(player2, 1)).to be(true)
      end
    end

    context 'when the board is occupied and no one is winning' do
      before do
        allow(game).to receive(:win?).with(player1).and_return(false)
        allow(game).to receive(:win?).with(player2).and_return(false)
        allow(game).to receive(:draw?).and_return(true)
      end

      it 'returns true for both players' do
        [player1, player2].each_with_index do |player, idx|
          expect { game.game_over_notice(player, idx) }.to output("\nIt\'s a draw. Good game!\n").to_stdout
          expect(game.game_over_notice(player, idx)).to be(true)
        end
      end
    end
  end

  describe '#game_over?' do
    context 'when no player is winning and it is not a draw' do
      it 'returns false for both players' do
        allow(game).to receive(:win?).with(player1).and_return(false)
        allow(game).to receive(:win?).with(player2).and_return(false)
        allow(game).to receive(:draw?).and_return(false)
        expect(game.game_over?(player1)).to be(false)
        expect(game.game_over?(player2)).to be(false)
      end
    end

    context 'when player 1 is winning' do
      it 'returns true for player 1 and false for player 2' do
        allow(game).to receive(:win?).with(player1).and_return(true)
        allow(game).to receive(:win?).with(player2).and_return(false)
        allow(game).to receive(:draw?).and_return(false)
        expect(game.game_over?(player1)).to be(true)
        expect(game.game_over?(player2)).to be(false)
      end
    end

    context 'when player 2 is winning' do
      it 'returns true for player 2 and false for player 1' do
        allow(game).to receive(:win?).with(player1).and_return(false)
        allow(game).to receive(:win?).with(player2).and_return(true)
        allow(game).to receive(:draw?).and_return(false)
        expect(game.game_over?(player1)).to be(false)
        expect(game.game_over?(player2)).to be(true)
      end
    end

    context 'when the board is occupied and no one is winning' do
      it 'returns true for both players' do
        allow(game).to receive(:win?).with(player1).and_return(false)
        allow(game).to receive(:win?).with(player2).and_return(false)
        allow(game).to receive(:draw?).and_return(true)
        expect(game.game_over?(player1)).to be(true)
        expect(game.game_over?(player2)).to be(true)
      end
    end
  end

  describe '#validate_move' do
    before do
      board.layout = [
        [1, 2, 3, '⛵', 5, '⚾', 7], [8, 9, 10, 11, '⛵', '⚾', 14],
        [15, 16, 17, 18, '⚾', '⛵', 21], [22, 23, 24, 25, 26, 27, '⚾'],
        [29, 30, 31, 32, 33, '⛵', 35], [36, 37, 38, 39, 40, 41, 42]
      ]
    end

    context 'when player 1 places their in a valid position' do
      it 'returns the coordinates of the position' do
        allow(player1).to receive(:make_choice).and_return('27')
        expect(game.validate_move(player1)).to eq([3, 5])
      end
    end

    context 'when player 2 places their in a valid position' do
      it 'returns the coordinates of the position' do
        allow(player2).to receive(:make_choice).and_return('7')
        expect(game.validate_move(player2)).to eq([0, 6])
      end
    end

    context 'when player 1 places their in a position that is taken' do
      it 'prints the warning message' do
        allow(player1).to receive(:make_choice).and_return('19', '27')
        warning = "\nThe position has been taken. Try again.\n"
        expect { game.validate_move(player1) }.to output(warning).to_stdout
      end
    end

    context 'when player 2 places their in a position that is taken' do
      it 'prints the warning message' do
        allow(player2).to receive(:make_choice).and_return('28', '40')
        warning = "\nThe position has been taken. Try again.\n"
        expect { game.validate_move(player2) }.to output(warning).to_stdout
      end
    end

    context 'when player 1 places their in a position that is out of range' do
      it 'prints the warning message' do
        allow(player1).to receive(:make_choice).and_return('1999', '27')
        warning = "\nInvalid position! Try only integers between 1 and #{board.valid_range}.\n"
        expect(player1).to receive(:make_choice).twice
        expect { game.validate_move(player1) }.to output(warning).to_stdout
      end
    end

    context 'when player 2 places their in a position that is out of range' do
      it 'prints the warning message' do
        allow(player2).to receive(:make_choice).and_return('99', '40')
        warning = "\nInvalid position! Try only integers between 1 and #{board.valid_range}.\n"
        expect(player2).to receive(:make_choice).twice
        expect { game.validate_move(player2) }.to output(warning).to_stdout
      end
    end
  end

  describe '#win?' do
    context 'when both players have made some moves but no one is winning' do
      it 'returns false for both players' do
        expect(game.win?(player1)).to be(false)
        expect(game.win?(player2)).to be(false)
      end
    end

    context 'when player 1 wins' do
      it 'returns true for player 1 and false for player 2' do
        player1.moves.concat([[0, 2], [0, 3]])
        player2.moves.concat([[2, 1]])
        expect(game.win?(player1)).to be(true)
        expect(game.win?(player2)).to be(false)
      end
    end

    context 'when player 2 wins' do
      it 'returns the true for player 2 and false for player 1' do
        player1.moves.concat([[0, 2], [4, 3]])
        player2.moves.concat([[2, 1], [3, 0]])
        expect(game.win?(player1)).to be(false)
        expect(game.win?(player2)).to be(true)
      end
    end
  end

  describe '#winning_pattern' do
    context 'when no player has made their moves yet' do
      it 'returns nil for both players' do
        expect(game.winning_pattern(player1)).to be_nil
        expect(game.winning_pattern(player2)).to be_nil
      end
    end

    context 'when both players have made some moves but no one is winning' do
      it 'returns nil for both players' do
        expect(game.winning_pattern(player1)).to be_nil
        expect(game.winning_pattern(player2)).to be_nil
      end
    end

    context 'when player 1 wins' do
      it 'returns the winning pattern for player 1 and nil for player 2' do
        player1.moves.concat([[0, 2], [0, 3]])
        player2.moves << [2, 1]
        expect(game.winning_pattern(player1)).to eq([[0, 3], [0, 2], [0, 1], [0, 0]])
        expect(game.winning_pattern(player2)).to be_nil
      end
    end

    context 'when player 2 wins' do
      it 'returns the winning pattern for player 2 and nil for player 1' do
        player1.moves.concat([[0, 2], [4, 3]])
        player2.moves.concat([[2, 1], [3, 0]])
        expect(game.winning_pattern(player1)).to be_nil
        expect(game.winning_pattern(player2)).to eq([[3, 0], [2, 1], [1, 2], [0, 3]])
      end
    end
  end

  describe '#track_moves' do
    context 'when no player has made their moves yet' do
      it 'returns an empty array' do
        expect(game.track_moves(player1, [], [1, 0])).to eq([])
        expect(game.track_moves(player2, [], [1, 0])).to eq([])
      end
    end

    context 'when both players have made moves' do
      context 'when the moves are tracked by moving to the next column' do
        it 'returns 1the array of coordinates that are in the way' do
          expect(game.track_moves(player1, [0, 0], [0, 1])).to eq([[0, 1], [0, 0]])
          expect(game.track_moves(player2, [0, 3], [0, 1])).to eq([[0, 3]])
        end
      end
    end

    context 'when both players have made moves' do
      context 'when the moves are tracked by moving to the next row and next column' do
        it 'returns 1the array of coordinates that are in the way' do
          expect(game.track_moves(player1, [0, 0], [1, 1])).to eq([[0, 0]])
          expect(game.track_moves(player2, [0, 3], [1, 1])).to eq([[0, 3]])
        end
      end
    end

    context 'when both players have made moves' do
      context 'when the moves are tracked by moving to the next row' do
        it 'returns 1the array of coordinates that are in the way' do
          expect(game.track_moves(player1, [0, 0], [1, 0])).to eq([[0, 0]])
          expect(game.track_moves(player2, [0, 3], [1, 0])).to eq([[0, 3]])
        end
      end
    end

    context 'when both players have made moves' do
      context 'when the moves are tracked by moving to the next row and previous column' do
        it 'returns 1the array of coordinates that are in the way' do
          expect(game.track_moves(player1, [0, 0], [1, -1])).to eq([[0, 0]])
          expect(game.track_moves(player2, [0, 3], [1, -1])).to eq([[1, 2], [0, 3]])
        end
      end
    end
  end

  describe '#draw?' do
    context 'when no player has made their moves yet' do
      it 'returns false' do
        expect(game.draw?).to eq(false)
      end
    end

    context 'when both players have made some moves but no one is winning' do
      it 'returns false' do
        board.layout = [
          [1, 2, 3, 4, '⛵', '⚾', 7], [8, 9, 10, 11, '⛵', 13, 14],
          [15, '⛵', 17, 18, 19, 20, 21], [22, 23, 24, 25, 26, 27, 28],
          [29, 30, 31, 32, 33, '⚾', 35], [36, 37, 38, 39, 40, 41, '⚾']
        ]
        expect(game.draw?).to eq(false)
      end
    end

    context 'when one of the players wins' do
      it 'returns false' do
        board.layout = [
          [1, 2, 3, '⛵', 5, '⚾', 7], [8, 9, 10, 11, '⛵', 13, 14],
          [15, 16, 17, 18, 19, '⛵', 21], [22, 23, 24, 25, 26, 27, '⛵'],
          [29, 30, 31, 32, 33, '⚾', 35], [36, 37, 38, 39, 40, 41, '⚾']
        ]
        expect(game.draw?).to eq(false)
      end
    end

    context 'when the board is occupied but no one wins' do
      it 'returns true' do
        board.layout = [
          ['⚾', '⚾', '⛵', '⚾', '⛵', '⚾', '⛵'],
          ['⛵', '⛵', '⛵', '⚾', '⚾', '⛵', '⛵'],
          ['⚾', '⛵', '⚾', '⛵', '⛵', '⚾', '⚾'],
          ['⛵', '⚾', '⛵', '⚾', '⚾', '⛵', '⛵'],
          ['⛵', '⚾', '⛵', '⚾', '⛵', '⛵', '⚾'],
          ['⚾', '⚾', '⛵', '⚾', '⚾', '⚾', '⛵']
        ]
        expect(game.draw?).to eq(true)
      end
    end
  end

  describe '#number_to_coordinate' do
    context 'when a number is entered' do
      it 'returns the quotient and remainder divided by the number of columns in the board' do
        expect(game.number_to_coordinate('42')).to eq([5, 6])
      end
    end
  end

  describe '#valid?' do
    context 'when a vaid position on the board is chosen' do
      it 'returns true' do
        expect(game.valid?('42')).to be(true)
      end
    end

    context 'when a position on the board that is out of range is entered' do
      it 'returns false' do
        expect(game.valid?('99')).to be(false)
      end
    end

    context 'when an invalid position on the board is entered' do
      it 'returns false' do
        expect(game.valid?('what?')).to be(false)
      end
    end
  end

  describe '#vacant?' do
    before do
      board.layout = [
        [1, 2, 3, '⛵', 5, '⚾', 7], [8, 9, 10, 11, '⛵', 13, 14],
        [15, 16, 17, 18, 19, '⛵', 21], [22, 23, 24, 25, 26, 27, '⛵'],
        [29, 30, 31, 32, 33, '⚾', 35], [36, 37, 38, 39, 40, 41, '⚾']
      ]
    end

    context 'when the player places their avatar in a valid position' do
      it 'returns true for an empty position' do
        coordinates = [5, 4]
        expect(game.vacant?(coordinates)).to be(true)
      end
    end

    context 'when the player places their avatar in an invalid position' do
      it 'returns false when player 1 makes the first move' do
        coordinates = [3, 6]
        expect(game.vacant?(coordinates)).to be(false)
      end
    end
  end
end
