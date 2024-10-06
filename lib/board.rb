# frozen_string_literal: true
require_relative 'errors'
class Board
  include CustomErrors

  attr_accessor :layout

  class << self
    attr_accessor :board_count
  end

  @board_count = 0
  BOARD_LIMIT = 1

  def initialize(row = 6, col = 7, counter = 1)
    @layout = Array.new(row) { Array.new(col) { counter += 1; counter - 1 } }
  end


end


b = Board.new(7, 8)
p b.layout
