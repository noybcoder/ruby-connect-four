# frozen_string_literal: true

require_relative 'errors'

# Board class that represents a game board in the Connect Four game.
class Board
  include CustomErrors

  attr_accessor :layout
  attr_reader :row, :column

  # Class-level constant to set the maximum limit of board
  class << self
    attr_accessor :board_count
  end

  @board_count = 0 # Create an instance variable to keep track of board count
  BOARD_LIMIT = 1 # Set the maximum limit of board

  # Public: Initializes a new Board instance.
  #
  # row - Number of rows (default: 6)
  # column - Number of columns (default: 7)
  # counter - Starting number to fill the board (default: 1)
  #
  # Raises an error if the number of boards exceeds the allowed limit.
  def initialize(row = 6, column = 7, counter = 1)
    @row = row # Set the number of rows
    @column = column # Set the number of columns
    # Create a 2D array representing the board layout, filled with sequential numbers
    @layout = Array.new(row) do
      Array.new(column) do
        counter += 1
        counter - 1
      end
    end
    # Increment the board count when a new board is created
    self.class.board_count += 1
    # Check if the number of boards exceeds the defined limit, raise an error if it does
    handle_game_violations(BoardLimitViolation, self.class.board_count, BOARD_LIMIT)
  end

  # Public: Returns the total number of cells on the board.
  #
  # This is used to validate whether a selected position is within the valid range.
  #
  # Returns the product of rows and columns.
  def valid_range
    row * column # Total number of cells on the board
  end

  # Public: Displays the current state of the board, with cells spaced dynamically.
  #
  # space - The number of spaces to use when centering cell values (default: 4).
  #
  # This method prints the board layout with horizontal dividers for better readability.
  # The width of the board is dynamically adjusted based on the number of columns and the specified spacing.
  def display_board(space = 4)
    # Calculate the total board width based on the number of columns and spacing
    board_width = (space + 1) * column + 1
    puts '-' * board_width # Print the top divider line
    layout.each do |row|
      print '|' # Start each row with a vertical divider
      # Print each row with centered values and vertical dividers between cells
      puts "#{row.map { |num| num.to_s.center(space) }.join('|')}|"
      puts '-' * board_width # Print the divider line after each row
    end
  end
end
