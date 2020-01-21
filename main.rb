require "curses"
require 'pp'
include Curses

begin
  # curses init
  noecho()
  init_screen()
  stdscr.keypad(true)
  #curs_set(0) # hide the cursor

  # TEMP
  # var init
  x = 0
  y = 0

  nb_lines = lines
  nb_cols = cols
  
  # Main loop
  while true
    # clear screen
    clear

    # show player
    setpos(y, x)
    addstr("@")

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
    end
  end
ensure
  close_screen()
end
