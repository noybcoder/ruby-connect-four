# frozen_string_literal: true

module Visualizable
  HEX_NUMBERS = (0..15).map { |num| num.to_s(16) }

  def avatar_unicodes
    HEX_NUMBERS.product(HEX_NUMBERS).map do |prefix, num|
      get_unicode("#{prefix}#{num}")
    end
  end

  def get_unicode(integer)
    ["26#{integer}".to_i(16)].pack('U*')
  end

  def display_avatars
    slice_size = 15
    avatar_unicodes.each_slice(slice_size).with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        idx = row_idx * slice_size + col_idx + 1
        print "#{idx}\. #{col}  "
      end
      puts "\n "
    end
  end
end

# v = Visualizable.new
# p v.store_avatars
