class Player
  def initialize
    @x = 0
    @y = 0

    @representation = "@"
  end

  def move(x, y, state)
    @x += x
    @y += y

    state.screen_update_required = true
  end

  attr_reader :x, :y, :representation
end
