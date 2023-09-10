# frozen_string_literal: true

class Tabletop
  attr_reader :width, :height
  def initialize(width:, height:)
    @width = width
    @height = height
  end

  def valid_position?(x:, y:)
    x.between?(0, width) && y.between?(0, height)
  end
end
