# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'visualizable'

# Game class that manages the game mechanics in the Connect Four game.
class Game
  include Visualizable

  # POSSIBLE_MOVES defines all directions in which a player can check for consecutive moves to win.
  POSSIBLE_MOVES = [[0, 1], [1, 1], [1, 0], [1, -1]].freeze

  attr_accessor :players, :board

  # Public: Initializes the game with a set of players and a game board.
  #
  # players - An array of Player objects participating in the game.
  # board - The game board where moves will be placed.
  def initialize(players, board)
    @players = players # Sets the list of players
    @board = board # Sets the game board
  end

  # Public: Manages turns for each player, allowing them to place their avatars on the board.
  #
  # Loops through each player, validates their move, updates the board, and checks if the game has ended (win or draw).
  def take_turns
    players.each_with_index do |player, idx|
      puts "\nPlayer #{idx + 1}, place your avatar in the board"
      # Validate and get the player's chosen move
      coord = validate_move(player)

      # Place the player's avatar at the chosen position on the board
      board.layout[coord[0]][coord[1]] = player.avatar
      # Add the move to the player's move history
      player.moves << coord

      # Display the updated board
      board.display_board
      # Check if the game has ended after this move
      break if game_over_notice(player, idx)
    end
  end

  # Public: Checks if the game is over due to a win or a draw, and notifies the players.
  #
  # player - The player who just made a move.
  # idx - The player's index.
  #
  # Returns true if the game is over (either a win or draw), false otherwise.
  def game_over_notice(player, idx)
    if win?(player)
      puts "\nPlayer #{idx + 1} wins!\n"
      return true
    elsif draw?
      puts "\nIt\'s a draw. Good game!\n"
      return true
    end
    false
  end

  # Public: Checks if the game is over (either by a win or a draw).
  #
  # player - The player whose moves are being checked.
  #
  # Returns true if the player has won or if the game is a draw.
  def game_over?(player)
    win?(player) || draw?
  end

  # Public: Validates the player's move, ensuring it is a valid and unoccupied position on the board.
  #
  # player - The player attempting to make a move.
  #
  # Loops until the player selects a valid and vacant position, then converts it to board coordinates.
  #
  # Returns the coordinates of the valid move.
  def validate_move(player)
    loop do
      # Get the player's input (position)
      position = player.make_choice
      # Check if the position is valid and vacant
      if valid?(position)
        coord = number_to_coordinate(position)
        return coord if vacant?(coord)

        puts "\nThe position has been taken. Try again." unless vacant?(coord)
      else
        puts "\nInvalid position! Try only integers between 1 and #{board.valid_range}." unless valid?(position)
      end
    end
  end

  # Public: Checks if the player has won the game.
  #
  # player - The player whose moves are being checked.
  #
  # Returns true if the player has a winning pattern, false otherwise.
  def win?(player)
    !winning_pattern(player).nil?
  end

  # Public: Checks for a winning pattern by examining the player's move history in all possible directions.
  #
  # player - The player whose moves are being checked.
  # avatars_needed - The number of consecutive avatars needed to win (default: 4).
  #
  # Returns the winning move sequence if found, nil otherwise.
  def winning_pattern(player, avatars_needed = 4)
    player.moves.each do |move_record|
      POSSIBLE_MOVES.each do |delta|
        # Track moves in each direction based on the current move and check if a winning pattern is found
        next_moves = track_moves(player, move_record, delta)
        return next_moves if next_moves.length == avatars_needed
      end
    end
    nil
  end

  # Public: Recursively tracks the player's moves in a given direction (delta) to find consecutive avatars.
  #
  # player - The player whose moves are being checked.
  # recorded_move - The move to start tracking from.
  # delta - The direction to check for consecutive moves.
  # move_tracker - Keeps track of consecutive moves (default: an empty array).
  #
  # Returns an array of consecutive moves in the given direction.
  def track_moves(player, recorded_move, delta, move_tracker = [])
    # Base case: If the current move is not in the player's move history, stop tracking.
    return move_tracker unless player.moves.include?(recorded_move)

    # Calculate the next move in the specified direction (delta)
    current_move = [recorded_move[0] + delta[0], recorded_move[1] + delta[1]]
    # Recursively track the next move
    track_moves(player, current_move, delta, move_tracker)
    # Add the current move to the move tracker
    move_tracker << recorded_move
  end

  # Public: Checks if the game is a draw.
  #
  # A draw occurs when all board positions are filled and no player has won.
  #
  # Returns true if the game is a draw, false otherwise.
  def draw?
    board.layout.all? { |row| row.all?(String) } && players.none? { |player| win?(player) }
  end

  # Public: Converts a board position (e.g., 1, 2, 3, ...) into row and column coordinates.
  #
  # position - The board position entered by the player.
  #
  # Returns an array of coordinates [row, column].
  def number_to_coordinate(position)
    (position.to_i - 1).divmod(board.column)
  end

  # Public: Validates if the player's chosen position is within the valid range of the board.
  #
  # position - The position chosen by the player (as a string).
  #
  # Returns true if the position is valid, false otherwise.
  def valid?(position)
    !!(position.match(/^\d+$/) && position.to_i.between?(1, board.valid_range))
  end

  # Public: Checks if a given set of coordinates on the board is vacant (i.e., not already occupied by an avatar).
  #
  # coordinates - The coordinates [row, column] to check.
  #
  # Returns true if the position is vacant, false otherwise.
  def vacant?(coordinates)
    board.layout[coordinates[0]][coordinates[1]].is_a?(Integer)
  end
end
