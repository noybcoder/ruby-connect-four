# frozen_string_literal: true

require_relative 'visualizable'
require_relative 'errors'

# Player class that represents a player in the Connect Four game.
class Player
  include CustomErrors
  include Visualizable
  attr_accessor :avatar, :moves

  # Class-level constant to set the maximum limit of players
  class << self
    attr_accessor :avatars
  end

  @avatars = [] # Create a class variable to keep track of player count
  PLAYER_LIMIT = 2 # Set the player limit

  # Public: Initializes a new Player instance.
  #
  # Returns a new Player object.
  def initialize
    @avatar = register_player # Register the player's avatar during initialization
    @moves = [] # Initialize the player's moves as an empty array
    # Check if the number of players exceeds the defined limit, raise an error if it does
    handle_game_violations(PlayerLimitViolation, self.class.avatars.size, PLAYER_LIMIT)
  end

  # Public: Prompts the player to select an avatar from the available list.
  #
  # It displays the list of avatars and ensures the selected avatar is unique.
  # If the selected avatar has already been taken, it asks the player to pick again.
  #
  # Returns the chosen avatar.
  def register_player
    # Prompt player to select an avatar, display avatars, and keep asking until a unique avatar is chosen
    puts "\nPlayer #{self.class.avatars.size + 1}, select your avatar (enter the number or copy the avatar):\n\n"
    display_avatars

    loop do
      response = select_avatar # Get avatar choice from the player
      # Return the avatar if it's unique, otherwise prompt to pick another one
      return self.class.avatars << response && response unless self.class.avatars.include?(response)

      puts 'The avatar has been chosen. Please pick a different one.'
    end
  end

  # Public: Handles the avatar selection process.
  #
  # The player can either choose an avatar by entering its corresponding number (between 1 and 256)
  # or by pasting the avatar directly if it falls within the Unicode range of valid avatars.
  #
  # Returns the selected avatar.
  def select_avatar
    loop do
      choice = make_choice # Get the player's input
      # Check if input is a number within the allowed range (1-256) and convert it to Unicode
      return convert_to_unicode(choice) if choice.match(/^\d+$/) && choice.to_i.between?(1, 256)
      # Check if input is a valid avatar within the Unicode range and return it directly
      return choice.strip if !choice.empty? && choice.unpack1('U*').between?(9728, 9983)

      # If input is invalid, prompt the player to enter a valid choice
      puts "Please only enter number between 1 and 256 or copy and paste the avatar.\n\n"
    end
  end

  # Public: Reads user input from the console.
  #
  # Returns the player's input as a string.
  def make_choice
    gets.chomp # Capture user input and remove leading/trailing whitespace
  end

  # Public: Converts a number to its corresponding Unicode avatar.
  #
  # number - The numerical string input (1-256) from the player.
  #
  # Converts the input number to a hexadecimal value, adjusts it to align with avatar Unicode values,
  # and returns the corresponding Unicode character.
  #
  # Returns a Unicode avatar.
  def convert_to_unicode(number)
    # Convert the number to a hexadecimal string and pad it with zeroes if necessary.
    # Then, convert it into a Unicode avatar.
    get_unicode((number.to_i - 1).to_s(16).rjust(2, '0'))
  end
end
