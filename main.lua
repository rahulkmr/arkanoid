local ball = require 'ball'
local platform = require 'platform'
local bricks = require 'bricks'
local walls = require 'walls'
local collisions = require 'collisions'
local levels = require 'levels'


function love.load()
    walls.construct_walls()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end
end


function love.update(dt)
    ball.update(dt)
    platform.update(dt)
    bricks.update(dt)
    walls.update(dt)
    collisions.resolve_collisions(ball, platform, walls, bricks)
    levels.switch_to_next_level(bricks, ball)
end


function love.draw()
    ball.draw()
    platform.draw()
    bricks.draw()
    walls.draw()
    if levels.game_finished then
        love.graphics.printf('Congratulations!\n' .. 'You have finisehd the game',
            300, 250, 200, 'center')
    end
end


function love.quit()
    print('Thanks for playing! Come back soon!')
end