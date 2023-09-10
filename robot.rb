# frozen_string_literal: true

require './tabletop'

class Robot
  attr_reader :x, :y, :tabletop, :facing

  VALID_FACINGS = %w( north east south west )

  class Error < StandardError; end

  def initialize(tabletop:)
    @tabletop = tabletop
  end

  def place(x:, y:, facing:)
    if tabletop.valid_position?(x: x, y: y) && valid_facing?(facing)
      @x, @y, @facing = x, y, facing
    else
      raise Error, 'x, y or facing is invalid.'
    end
  end

  def left
    @facing = VALID_FACINGS[facing_index(facing: facing, valid_facings: VALID_FACINGS) - 1]
  end

  def right
    @facing = VALID_FACINGS.reverse[facing_index(facing: facing, valid_facings: VALID_FACINGS.reverse) - 1]
  end

  def move
    raise(Error, 'Robot must be place on tabletop') unless placed?

    case facing
    when 'north'
      @y += 1 if tabletop.valid_position?(x: x, y: y + 1)
    when 'east'
      @x += 1 if tabletop.valid_position?(x: x + 1, y: y)
    when 'south'
      @y -= 1 if tabletop.valid_position?(x: x, y: y - 1)
    when 'west'
      @x -= 1 if tabletop.valid_position?(x: x - 1, y: y)
    end
  end

  def report
    puts <<~STRING
    x: #{x}
    y: #{y}
    f: #{facing}
    STRING
  end

  def placed?
    !(x.nil? || y.nil? || facing.nil?)
  end

  private
    def valid_facing?(facing)
      VALID_FACINGS.include? facing
    end

    def facing_index(facing:, valid_facings:)
      valid_facings.index(facing)
    end
end