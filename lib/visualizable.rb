# frozen_string_literal: true

# Visualizable module provides methods for converting avatars from integers to Unicode characters
# and displaying them in a grid format.
module Visualizable
  # HEX_NUMBERS holds an array of hexadecimal digits (0-15) represented as strings,
  # which will be used to generate combinations of two-digit hexadecimals.
  HEX_NUMBERS = (0..15).map { |num| num.to_s(16) }

  # Public: Generates an array of Unicode characters based on two-digit hexadecimal combinations.
  #
  # Combines the elements of HEX_NUMBERS with each other, forming all possible two-digit hex values,
  # and then converts each pair into a Unicode character.
  #
  # Returns an array of Unicode characters.
  def avatar_unicodes
    HEX_NUMBERS.product(HEX_NUMBERS).map do |prefix, num|
      get_unicode("#{prefix}#{num}")
    end
  end

  # Public: Converts a hexadecimal string into its corresponding Unicode character.
  #
  # integer - A string representation of a two-digit hexadecimal number (e.g., '00', 'ff').
  #
  # The method prefixes '26' to the given integer string to generate a valid Unicode hex value,
  # converts it from hexadecimal to an integer, and packs it into a Unicode character.
  #
  # Returns a Unicode character.
  def get_unicode(integer)
    # Converts the hexadecimal string '26XX' into an integer, where 'XX' is the provided two-digit hex.
    # Then packs the integer into a Unicode character using the 'U*' directive.
    ["26#{integer}".to_i(16)].pack('U*')
  end

  # Public: Displays the generated Unicode avatars in a grid-like format.
  #
  # The method prints the avatars in rows, each with an index. It slices the list of avatars into
  # smaller groups (rows) of a specified size (15 avatars per row) and displays each row in a well-formatted output.
  #
  # Each avatar is labeled with its corresponding index number for reference.
  def display_avatars
    slice_size = 15 # Number of avatars per row
    # Iterate through avatars in slices, where each slice represents a row
    avatar_unicodes.each_slice(slice_size).with_index do |row, row_idx|
      # Iterate through each avatar in the row, printing the index and avatar
      row.each_with_index do |col, col_idx|
        idx = row_idx * slice_size + col_idx + 1
        # Print index and avatar with spacing
        print "#{idx}\. #{col}  "
      end
      # Print a new line at the end of each row
      puts "\n "
    end
  end
end
