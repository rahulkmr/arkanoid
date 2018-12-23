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
bricks.rows = 8
bricks.columns = 11
bricks.x = 70
bricks.y = 50
bricks.width = 50
bricks.height = 30
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.current_level_bricks = {}

function bricks.construct_level()
    for row = 1, bricks.rows do
        for col = 1, bricks.columns do
            local new_brick_x = bricks.x +
                (col - 1) * (bricks.width + bricks.horizontal_distance)
            local new_brick_y = bricks.y +
                (row - 1) * (bricks.height + bricks.vertical_distance)
            local new_brick = bricks.new_brick(new_brick_x, new_brick_y)
            bricks.add_to_current_level(new_brick)
        end
    end
end

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


local walls = {}
walls.thickness = 20
walls.current_level_walls = {}

function walls.new_wall(x, y, width, height)
    return ({
        x = x,
        y = y,
        width = width,
        height = height
    })
end

function walls.construct_walls()
    local left_wall = walls.new_wall(
        0,
        0,
        walls.thickness,
        love.graphics.getHeight()
    )
    local right_wall = walls.new_wall(
        love.graphics.getWidth() - walls.thickness,
        0,
        walls.thickness,
        love.graphics.getHeight()
    )
    local top_wall = walls.new_wall(
        0,
        0,
        love.graphics.getWidth(),
        walls.thickness
    )
    local bottom_wall = walls.new_wall(
        0,
        love.graphics.getHeight() - walls.thickness,
        love.graphics.getWidth(),
        walls.thickness
    )
    walls.current_level_walls['left'] = left_wall
    walls.current_level_walls['right'] = right_wall
    walls.current_level_walls['top'] = top_wall
    walls.current_level_walls['bottom'] = bottom_wall
end

function walls.draw_wall(wall)
    love.graphics.rectangle('line',
        wall.x, wall.y, wall.width, wall.height)
end

function walls.update_wall(dt)

end

function walls.update(dt)
    for _, wall in pairs(walls.current_level_walls) do
        walls.update_wall(wall)
    end
end


function walls.draw()
    for _, wall in pairs(walls.current_level_walls) do
        walls.draw_wall(wall)
    end
end


function love.load()
    bricks.construct_level()
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
end


function love.draw()
    ball.draw()
    platform.draw()
    bricks.draw()
    walls.draw()
end


function love.quit()
    print('Thanks for playing! Come back soon!')
end