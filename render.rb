DEBUG_MODE = true
DEBUG_LOG = true
DEBUG_MESSAGE = true

MAX_MESSAGES = 10

class NullRenderer
  def render(state)
    pass
  end
end


class CursesRenderer
  def initialize
    noecho()
    init_screen()
    start_color()
    stdscr.keypad(true)
    curs_set(0) # hide the cursor
    stdscr.nodelay=(true) # do not wait for keypress

    $messages = []
    $messages_count = []

    @screen_update_required = true
    @last_screen_update = Time.now
  end

  def get_input
    getch
  end

  def cleanup
    close_screen()
  end

  def debug(text)
    if DEBUG_MODE
      if DEBUG_MESSAGE
        message("[dbg]> " + text)
      end
      if DEBUG_LOG
        debug_log(text)
      end
    end
  end

  def message(text)
    if $messages.last == text
      $messages_count[-1] += 1
    else
      $messages << text
      $messages_count << 1
    end

    if $messages.length > MAX_MESSAGES
      $messages = $messages.drop(1)
      $messages_count = $messages_count.drop(1)
    end

    @screen_update_required = true
  end
  
  def render(state)
    if @screen_update_required
      true_render
    else
      delta = Time.now - @last_screen_update
      if delta >= 0.5 # force an update every 0.5 second (to make a clock more precise)
        true_render
      end
    end
  end

  private

  def true_render
    clear

    setpos(0, 0)
    addstr(Time.now.getutc.to_s)

    display_messages

    refresh

    @screen_update_required = false
    @last_screen_update = Time.now
  end

  def nb_cols
    cols
  end

  def nb_lines
    lines
  end

  def display_messages
    # we set the correct curses color
    Curses.attrset(Curses.color_pair(1) | Curses::A_BOLD)

    # revering the order of messages
    tmp_messages = $messages
    tmp_messages.reverse
    tmp_counts = $messages_count
    tmp_counts.reverse

    # preparing index
    index = 0
    
    # going to the right place
    setpos(nb_lines-$messages.length, 0)

    # we loop throught the messages
    for message in tmp_messages
      if tmp_counts[index] == 1
        # if we have 1 message, we don't show the number
        addstr(message + "\n")
      else
        addstr(message + " (#{$messages_count[index]} times)\n")
        # if we have more than 1, we do
      end

      # we increment our index
      index += 1
    end

    # we display the last message
    # we set the right color
    Curses.attrset(Curses.color_pair(0) | Curses::A_BOLD)

    # if we have a last message
    if tmp_messages.length > 0
      setpos(nb_lines - 1, 0) # we go to the bottom

      # same as above
      if tmp_counts.last == 1
        addstr(tmp_messages.last + "\n")
      else
        addstr("#{tmp_messages.last} (#{tmp_counts.last} times)\n")
      end
    end
   
    # we reset the color
    Curses.attrset(Curses.color_pair(0) | Curses::A_NORMAL)
  end

  def debug_log(text) # TODO
  end
end
