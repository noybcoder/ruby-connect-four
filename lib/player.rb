# frozen_string_literal: true

require_relative 'visualizable'
require_relative 'errors'

class Player
  include Visualizable, CustomErrors
  attr_accessor :avatar

  class << self
    attr_accessor :avatars
  end

  @avatars = []
  PLAYER_LIMIT = 2

  def initialize
    @avatar = register_player
    handle_game_violations(PlayerLimitViolation, player_numbers, PLAYER_LIMIT)
  end

  def register_player
    puts "Player #{player_numbers + 1}, select your avatar (enter the number on the left or copy and paste the avatar):\n\n"
    display_avatars

    loop do
      response = select_avatar
      return self.class.avatars << response && response unless self.class.avatars.include?(response)

      puts 'The avatar has been chosen. Please pick a different one.'
    end
  end

  def select_avatar
    loop do
      choice = gets.chomp
      return convert_to_unicode(choice) if choice.match(/^\d+$/) && choice.to_i.between?(1, 256)
      return choice.strip if choice.unpack1('U*').between?(9728, 9983)

      puts "Please only enter number between 1 and 256 or copy and paste the avatar.\n\n"
    end
  end

  def convert_to_unicode(number)
    get_unicode((number.to_i - 1).to_s(16).rjust(2, '0'))
  end

  def player_numbers
    self.class.avatars.length
  end
end

p1 = Player.new
p2 = Player.new
p3 = Player.new
p p1.avatar
p p2.avatar

p p3.avatar
