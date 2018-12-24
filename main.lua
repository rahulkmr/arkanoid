local ball = require 'ball'
local platform = require 'platform'
local bricks = require 'bricks'
local walls = require 'walls'
local collisions = require 'collisions'
local levels = require 'levels'

local gamestate = 'menu'

function love.load()
    walls.construct_walls()
    bricks.construct_level(levels.require_current_level())
end

function love.keypressed(key)
    if gamestate == 'menu' then
        if key == 'return' then
            gamestate = 'game'
        elseif key == 'escape' then
            love.event.quit()
        end
    elseif gamestate == 'game' then
        if key == 'escape' then
            gamestate = 'gamepaused'
        end
    elseif gamestate == 'gamepaused' then
        if key == 'return' then
            gamestate = 'game'
        elseif key == 'escape' then
            love.event.quit()
        end
    elseif gamestate == 'gamefinished' then
        if key == 'return' then
            levels.current_level = 1
            level = levels.require_current_level()
            bricks.construct_level(level)
            ball.reposition()
            gamestate = 'game'
        elseif key == 'escape' then
            love.event.quit()
        end
    end
end

function switch_to_next_level(bricks, ball)
    if #bricks.current_level_bricks == 0 then
        if levels.current_level < #levels.sequence then
            levels.current_level = levels.current_level + 1
            level = levels.require_current_level()
            bricks.construct_level(level)
            ball.reposition()
        else
            gamestate = 'gamefinished'
        end
    end
end



function love.update(dt)
    if gamestate == 'menu' then
    elseif gamestate == 'game' then
        ball.update(dt)
        platform.update(dt)
        bricks.update(dt)
        walls.update(dt)
        collisions.resolve_collisions(ball, platform, walls, bricks)
        switch_to_next_level(bricks, ball, gamestate)
    elseif gamestate == 'gamepaused' then
    elseif gamestate == 'gamefinished' then
    end
end


function love.draw()
    if gamestate == 'menu' then
        love.graphics.print('Press Enter to continue', 280, 250)
    else
        ball.draw()
        platform.draw()
        bricks.draw()
        walls.draw()
        if gamestate == 'gamepaused' then
            love.graphics.print('Game is paused. Press Enter to continue or Esc to quit',
                50, 50)
        elseif gamestate == 'gamefinished' then
            love.graphics.printf('Congratulations!\n' .. 
            'You have finisehd the game\n' ..
            'Press Enter to restart or Esc to quit',
                300, 250, 200, 'center')
        end
    end
end


function love.quit()
    print('Thanks for playing! Come back soon!')
end