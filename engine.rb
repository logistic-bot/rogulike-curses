# The game engine, used to interact with the game state and ask for
# render call
class Engine
  def initialize(renderer=nil, state=nil)
    if renderer == nil
      @renderer = CursesRenderer.new
    else
      @renderer = renderer
    end

    if state == nil
      @state = State
    else
      @state = state
    end
  end

  def render
    @renderer.render(@state)
  end

  def handle_input_events
    input = @renderer.get_input

    debug("input: #{input}") unless input == nil
  end

  def debug(text)
    @renderer.debug(text)
  end

  def main_loop
    begin
      while true
        render
        handle_input_events
        sleep 0.0003
      end
    ensure
      @renderer.cleanup
    end
  end
end
