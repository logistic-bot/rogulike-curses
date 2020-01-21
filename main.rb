require "curses"
require 'pp'
include Curses

$messages = []
$messages_count = []

DEBUG_MODE = true
MAX_MESSAGES = 5

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
end

def debug(text)
  if DEBUG_MODE
    message("[dbg]> " + text)
  end
end

def display_messages
  Curses.attrset(Curses.color_pair(1) | Curses::A_BOLD)

  index = 0
  for message in $messages
    setpos(nb_lines - 1 - index, 0)

    if $messages_count[index] == 1
      addstr(message)
    else
      addstr(message + " (#{$messages_count[index]} times)")
    end

    index += 1
  end

  Curses.attrset(Curses.color_pair(0) | Curses::A_BOLD)

  if $messages.length > 0
    setpos(nb_lines - index, 0)

    if $messages_count.last == 1
      addstr(" > " + $messages.last)
    else
      addstr(" > #{$messages.last} (#{$messages_count.last} times)")
    end
  end

  Curses.attrset(Curses.color_pair(0) | Curses::A_NORMAL)
end

def nb_cols
  cols
end

def nb_lines
  lines
end

begin
  # curses init
  noecho()
  init_screen()
  start_color()
  stdscr.keypad(true)
  curs_set(0) # hide the cursor
  debug("Curses initialized")

  # TEMP
  # var init
  x = 0
  y = 0

  debug("Entering Main Loop")
  # Main loop
  while true
    debug("Tick")
    
    # clear screen
    clear

    # show player
    setpos(y, x)
    addstr("@")

    # debug
    debug("Player pos: #{y}, #{x}")

    # print messages
    display_messages

    # move cursor out of the way
    setpos(nb_lines-1, nb_cols-1) # we need the '-1' because the index start at 0

    # refresh screen
    refresh

    # get key
    key = getch

    # handle key
    case key
    when Curses::Key::DOWN then y+=1
    when Curses::Key::UP then y-=1
    when Curses::Key::LEFT then x-=1
    when Curses::Key::RIGHT then x+=1

    when "2" then y+=1
    when "8" then y-=1
    when "4" then x-=1
    when "6" then x+=1

    when "7" then
      y-=1
      x-=1
    when "9" then
      y-=1
      x+=1
    when "1" then
      y+=1
      x-=1
    when "3" then
      y+=1
      x+=1

    when "q" then break # quit
    when 27 then break # quit
    # 27 is the keycode for ESCAPE

    else debug("Unhandeled key `#{key}`")
    end
  end
ensure
  close_screen()
  pp $messages
  pp $messages_count
end

