# frozen_string_literal: true

require_relative 'errors'
class Board
  include CustomErrors

  attr_accessor :layout
  attr_reader :row, :column

  class << self
    attr_accessor :board_count
  end

  @board_count = 0
  BOARD_LIMIT = 1

  def initialize(row = 6, column = 7, counter = 1)
    @row = row
    @column = column
    @layout = Array.new(row) do
      Array.new(column) do
        counter += 1
        counter - 1
      end
    end
    self.class.board_count += 1
    handle_game_violations(BoardLimitViolation, self.class.board_count, BOARD_LIMIT)
  end

  def valid_range
    row * column
  end

  def display_board(space = 4)
    board_width = (space + 1) * column + 1 # Adjust for dynamic board width
    puts '-' * board_width
    layout.each do |row|
      print '|'
      puts "#{row.map { |num| num.to_s.center(space) }.join('|')}|"
      puts '-' * board_width
    end
  end
end
