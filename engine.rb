# The game engine, used to interact with the game state and ask for
# render call
class Engine
  def initialize(renderer=nil, state=nil)
    if state == nil
      @state = State.new
    else
      @state = state
    end

    if renderer == nil
      @renderer = CursesRenderer.new(@state)
    else
      @renderer = renderer
    end
  end

  def render
    @renderer.render()
  end

  def handle_input_events
    input = @renderer.get_input

    debug("input: #{input}") unless input == nil
  end

  def debug(text)
    @renderer.debug(text)
  end

  def main_loop
    info("Starting main loop")
    begin
      while true
        render
        handle_input_events
        sleep 0.0003
      end
    ensure
      info("Programm exit!!")
      debug("Cleanup")
      @renderer.cleanup

      pp self
    end
  end

  def info(text)
    @renderer.info(text)
  end
end
