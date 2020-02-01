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

    action = nil

    unless input == nil
      case input
      when "q"
        action = Action::Quit.new
        
      when Curses::Key::UP
        action = Action::MoveUp.new
      when Curses::Key::DOWN
        action = Action::MoveDown.new
      when Curses::Key::LEFT
        action = Action::MoveLeft.new
      when Curses::Key::RIGHT
        action = Action::MoveRight.new

      when "8"
        action = Action::MoveUp.new
      when "2"
        action = Action::MoveDown.new
      when "4"
        action = Action::MoveLeft.new
      when "6"
        action = Action::MoveRight.new

      when "5"
        action = nil

      when "7"
        action = Action::MoveUpLeft.new
      when "9"
        action = Action::MoveUpRight.new
      when "1"
        action = Action::MoveDownLeft.new
      when "3"
        action = Action::MoveDownRight.new
      end

      debug("input: #{input}") unless input == nil
      debug("action: #{action}")
    end

    return action
  end

  def debug(text)
    @renderer.debug(text)
  end

  def main_loop
    info("Starting main loop")
    begin
      while true
        update_state
        
        render

        action = handle_input_events
        result = nil
        result = action.execute(@state) unless action == nil

        if result == :quit # TODO find a way to detect if the object has an execute method
          break
        elsif result == nil
        else
          @state.message(result)
        end

        sleep 0.0003
      end
    ensure
      info("Programm exit!!")
      debug("Cleanup")
      @renderer.cleanup
    end
  end

  def update_state
    @state.nb_lines = @renderer.nb_lines
    @state.nb_cols = @renderer.nb_cols
  end

  def info(text)
    @renderer.info(text)
  end
end
