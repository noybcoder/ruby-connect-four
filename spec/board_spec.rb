# frozen_string_literal: true

require './lib/board'

RSpec.describe Board do
  subject(:board) { Board.new }

  before do
    Board.board_count = 0
  end

  describe '#valid_range' do
    context 'when the board object is initialized' do
      it 'returns the area of the board' do
        expect(board.valid_range).to eq(42)
      end
    end
  end

  describe '#display_board' do
    context 'when nobody makes any moves at the beginning' do
      it 'prints the grid with all numbers' do
        expected_output = <<~GRID
          ------------------------------------
          | 1  | 2  | 3  | 4  | 5  | 6  | 7  |
          ------------------------------------
          | 8  | 9  | 10 | 11 | 12 | 13 | 14 |
          ------------------------------------
          | 15 | 16 | 17 | 18 | 19 | 20 | 21 |
          ------------------------------------
          | 22 | 23 | 24 | 25 | 26 | 27 | 28 |
          ------------------------------------
          | 29 | 30 | 31 | 32 | 33 | 34 | 35 |
          ------------------------------------
          | 36 | 37 | 38 | 39 | 40 | 41 | 42 |
          ------------------------------------
        GRID
        expect { board.display_board }.to output(expected_output).to_stdout
      end
    end

    context 'when both players have made some moves' do
      it 'prints the grid with numbers and avatars' do
        board.layout[2][2] = '⛹'
        board.layout[3][3] = '⛎'
        expected_output = <<~GRID
          ------------------------------------
          | 1  | 2  | 3  | 4  | 5  | 6  | 7  |
          ------------------------------------
          | 8  | 9  | 10 | 11 | 12 | 13 | 14 |
          ------------------------------------
          | 15 | 16 | ⛹  | 18 | 19 | 20 | 21 |
          ------------------------------------
          | 22 | 23 | 24 | ⛎  | 26 | 27 | 28 |
          ------------------------------------
          | 29 | 30 | 31 | 32 | 33 | 34 | 35 |
          ------------------------------------
          | 36 | 37 | 38 | 39 | 40 | 41 | 42 |
          ------------------------------------
        GRID
        expect { board.display_board }.to output(expected_output).to_stdout
      end
    end
  end
end
