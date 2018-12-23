local ball = {}
ball.x = 300
ball.y = 300
ball.radius = 10
ball.speed_x = 300
ball.speed_y = 300

function ball.draw()
    local segments_in_circle = 16
    love.graphics.circle('line', ball.x, ball.y, ball.radius, segments_in_circle)
end

function ball.update(dt)
    ball.x = ball.x + ball.speed_x * dt
    ball.y = ball.y + ball.speed_y * dt
end


local platform = {}
platform.x = 500
platform.y = 500
platform.width = 70
platform.height = 20
platform.speed_x = 300

function platform.draw()
    love.graphics.rectangle('line', platform.x, platform.y, platform.width, platform.height)
end

function platform.update(dt)
    if love.keyboard.isDown('right') then
        platform.x = platform.x + platform.speed_x * dt
    end

    if love.keyboard.isDown('left') then
        platform.x = platform.x - platform.speed_x * dt
    end
end


local bricks = {}

bricks.current_level_bricks = {}
bricks.width = 50
bricks.height = 30

function bricks.new_brick(x, y, width, height)
    return ({
        x = x,
        y = y,
        width = width or bricks.width,
        height = height or bricks.height
    })
end

function bricks.draw_brick(brick)
    love.graphics.rectangle('line', brick.x, brick.y, brick.width, brick.height)
end

function bricks.update_brick(brick)

end

function bricks.add_to_current_level(brick)
    table.insert(bricks.current_level_bricks, brick)
end

function bricks.draw()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.draw_brick(brick)
    end
end

function bricks.update(dt)
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.update_brick(brick)
    end
end


function love.load()
    bricks.add_to_current_level(bricks.new_brick( 100, 100))
    bricks.add_to_current_level(bricks.new_brick( 160, 100))
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
end


function love.draw()
    ball.draw()
    platform.draw()
    bricks.draw()
end


function love.quit()
    print('Thanks for playing! Come back soon!')
end