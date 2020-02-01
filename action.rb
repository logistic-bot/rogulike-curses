module Action
  class Move
    def initialize(y, x)
      @y = y
      @x = x
    end

    def execute(state)
      min_x = 0
      min_y = 0

      max_x = state.nb_cols
      max_y = state.nb_lines

      new_x = state.player.x + @x
      new_y = state.player.y + @y

      hit_min_x = new_x < min_x
      hit_min_y = new_y < min_y

      hit_max_x = new_x >= max_x
      hit_max_y = new_y >= max_y

      hit = hit_min_x || hit_min_y || hit_max_x || hit_max_y # for some WIERD
      # REASON that I can not understand, it DOES NOT WORK with `or`, you NEED
      # to use `or` FOR SOME REASON

      state.debug("hit: min_x: #{hit_min_x}, min_y: #{hit_min_y},
                   max_x: #{hit_max_x}, max_y = #{hit_max_y}")

      state.debug("min_x: #{min_x}")
      state.debug("min_y: #{min_y}")
      state.debug("max_x: #{max_x}")
      state.debug("max_y: #{max_y}")
      state.debug("new: #{new_x},#{new_y}")
      state.debug("hit: #{hit}")

      if hit
        'You hit the Border'
      else
        state.player.move(@x, @y, state)
        nil
      end
    end
  end

  class MoveUp
    def execute(state)
      return Action::Move.new(-1, 0).execute(state) # cordinates in y, x form
    end
  end

  class MoveDown
    def execute(state)
      return Action::Move.new(1, 0).execute(state) # cordinates in y, x form
    end
  end

  class MoveLeft
    def execute(state)
      return Action::Move.new(0, -1).execute(state)
    end
  end

  class MoveRight
    def execute(state)
      return Action::Move.new(0, 1).execute(state)
    end
  end

  class MoveUpLeft
    def execute(state)
      return Action::Move.new(-1, -1).execute(state)
    end
  end

  class MoveUpRight
    def execute(state)
      return Action::Move.new(-1, 1).execute(state)
    end
  end

  class MoveDownLeft
    def execute(state)
      return Action::Move.new(1, -1).execute(state)
    end
  end

  class MoveDownRight
    def execute(state)
      return Action::Move.new(1, 1).execute(state)
    end
  end

  class Quit
    def execute(state)
      return :quit
    end
  end
end
