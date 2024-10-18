# frozen_string_literal: true

require './lib/game'

player1 = Player.new # Register the first player
player2 = Player.new # Register the second player
board = Board.new # Set up the game board
game = Game.new([player1, player2], board) # Set up the game

# Play game
loop do
  return if game.game_over?(player1) || game.game_over?(player2)

  game.take_turns
end
