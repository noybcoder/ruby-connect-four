# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'visualizable'

class Game
  include Visualizable

  POSSIBLE_MOVES = [[0, 1], [1, 1], [1, 0], [1, -1]].freeze

  attr_accessor :players, :board

  def initialize(players, board)
    @players = players
    @board = board
  end

  def play(player1, player2)
    loop do
      return if game_over(player1) || game_over(player2)

      take_turns
    end
  end

  def take_turns
    players.each_with_index do |player, idx|
      puts "\nPlayer #{idx + 1}, place your avatar in the board"
      coord = validate_move(player)

      board.layout[coord[0]][coord[1]] = player.avatar
      player.moves << coord

      board.display_board
      break if game_over_notice(player, idx)
    end
  end

  def game_over_notice(player, idx)
    if win?(player)
      puts "\nPlayer #{idx + 1} wins!\n"
      return true
    elsif draw?(player)
      puts "\nIt\'s a draw. Good game!\n"
      return true
    end
    false
  end

  def game_over(player)
    win?(player) || draw?(player)
  end

  def validate_move(player)
    loop do
      position = player.make_choice
      if valid?(position)
        coord = number_to_coordinate(position)
        return coord if vacant?(coord)

        puts "\nThe position has been taken. Try again." unless vacant?(coord)
      else
        puts "\nInvalid position! Try only integers between 1 and #{board.valid_range}." unless valid?(position)
      end
    end
  end

  def win?(player)
    !winning_pattern(player).nil?
  end

  def winning_pattern(player, avatars_needed = 4)
    player.moves.each do |move_record|
      POSSIBLE_MOVES.each do |delta|
        next_moves = track_moves(player, move_record, delta)
        return next_moves if next_moves.length == avatars_needed
      end
    end
    nil
  end

  def track_moves(player, recorded_move, delta, move_tracker = [])
    return move_tracker unless player.moves.include?(recorded_move)

    current_move = [recorded_move[0] + delta[0], recorded_move[1] + delta[1]]
    track_moves(player, current_move, delta, move_tracker)
    move_tracker << recorded_move
  end

  def draw?(player)
    board.layout.all? { |row| row.all?(String) } && !win?(player)
  end

  def number_to_coordinate(position)
    (position.to_i - 1).divmod(board.column)
  end

  def valid?(position)
    position.match(/^\d+$/) && position.to_i.between?(1, board.valid_range)
  end

  def vacant?(coordinates)
    board.layout[coordinates[0]][coordinates[1]].is_a?(Integer)
  end
end

player1 = Player.new
player2 = Player.new
board = Board.new
game = Game.new([player1, player2], board)
game.play(player1, player2)

# [[0, 2], [0, 4], [1, 2], [2, 2], [3, 2]].each do |dx, dy|
#   board.layout[dx][dy] = '⛎'
# end

# p game.winning_pattern(player2, [3, 2])
