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

function ball.bounding_rectangle()
    return ({
        x = ball.x - ball.radius,
        y = ball.y - ball.radius,
        width = 2 * ball.radius,
        height = 2 * ball.radius
    })
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


local collisions = {}

function collisions.resolve_collisions()
    collisions.ball_platform_collision(ball, platform)
    collisions.ball_walls_collision(ball, walls)
    collisions.ball_bricks_collision(ball, bricks)
    collisions.platform_walls_collision(platform, walls)
end

function collisions.check_rectangle_overlap(a, b)
    local overlap = false
    local shift_b_x, shift_b_y = 0, 0
    if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
            a.y + a.height < b.y or b.y + b.height < a.y ) then
        overlap = true
        if (a.x + a.width / 2) < (b.x + b.width / 2) then
            shift_b_x = (a.x + a.width) - b.x
        else
            shift_b_x = a.x - (b.x + b.width)
        end
        if (a.y + a.height / 2) < (b.y + b.height / 2) then
            shift_b_y = (a.y + a.height) - b.y
        else
            shift_b_y = a.y - (b.y + b.height)
        end
    end
    return overlap, shift_b_x, shift_b_y
end

function collisions.ball_platform_collision(ball, platform)
    if collisions.check_rectangle_overlap(ball.bounding_rectangle(), platform) then
        print('ball-platform collision')
    end
end

function collisions.ball_bricks_collision(ball, bricks)
    ball_bounding_rectange = ball.bounding_rectangle()
    for _, brick in pairs(bricks.current_level_bricks) do
        if collisions.check_rectangle_overlap(ball_bounding_rectange, brick) then
            print('ball-brick collision')
        end
    end
end

function collisions.ball_walls_collision(ball, walls)
    ball_bounding_rectange = ball.bounding_rectangle()
    for _, wall in pairs(walls.current_level_walls) do
        if collisions.check_rectangle_overlap(ball_bounding_rectange, wall) then
            print('ball-wall collision')
        end
    end
end

function collisions.platform_walls_collision(platform, walls)
    for _, wall in pairs(walls.current_level_walls) do
        if collisions.check_rectangle_overlap(platform, wall) then
            print('ball-wall collision')
        end
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
    collisions.resolve_collisions()
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