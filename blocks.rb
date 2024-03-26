# Yet another raylib wrapper for Ruby
#
# * https://github.com/vaiorabbit/raylib-bindings
#
# Demonstrates several key features including:
# * Core      : window management, camera, etc.
# * Gameplay  : fetching player input, collision handling, etc.
# * Rendering : drawing shapes, texts, etc.
#
# To get more information, see:
# * https://www.raylib.com/cheatsheet/cheatsheet.html for API reference
# * https://github.com/vaiorabbit/raylib-bindings/tree/main/examples for more actual codes written in Ruby

require 'raylib'
require_relative './board.rb'
require_relative './clock.rb'
require_relative './canvas.rb'
require_relative './raylib_include.rb'

def next_state(state)
  state += 1
  state = 0 if state > 2
  state
end

if __FILE__ == $PROGRAM_NAME
    puts "Creating new clock"
  clock = Clock.new
  puts "new clock created. (tick = #{clock.tick})"

  board = Board.new(40, 40)
  board.fill_row(3, Canvas::YELLOW)
  canvas = Canvas.new(1280, 720)

  canvas.set_scene([board])

  until WindowShouldClose()
    clock.advance

    if (clock.tick % 300_000).zero? 
      canvas.paint
    end    
  end

  CloseWindow()
end
