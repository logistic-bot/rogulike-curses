require "logger"

DEBUG_MODE = true
DEBUG_LOG = true
DEBUG_MESSAGE = true
DEBUG_LEVEL = Logger::Severity::DEBUG

LOGGER = Logger.new("log.log", DEBUG_LEVEL)

MAX_MESSAGES = 10

class State
  def initialize
    @map = Map.new
    @player = Player.new
    @objects = [@player]

    @all_messages = []
    @current_messages = []
    @current_messages_count = []

    @screen_update_required = true
  end

  def message(text)
    if @current_messages.last == text
      @current_messages_count[-1] += 1
    else
      @current_messages << text
      @all_messages << text
      @current_messages_count << 1
    end

    if @current_messages.length > MAX_MESSAGES
      @current_messages = @current_messages.drop(1)
      @current_messages_count = @current_messages_count.drop(1)
    end

    @screen_update_required = true
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

  def info(text)
    if DEBUG_MODE
      if DEBUG_MESSAGE
        message("[info]> " + text)
      end

      if DEBUG_LOG
        LOGGER.info(text)
      end
    end
  end

  attr_reader :current_messages, :current_messages_count, :objects
  attr_accessor :screen_update_required

  private

  def debug_log(text)
    LOGGER.debug("#{text}")
  end
end

private

# stores terrain and objects
class Map
end

