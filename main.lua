local ball = {}
ball.x = 200
ball.y = 500
ball.radius = 10
ball.speed_x = 700
ball.speed_y = 700

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

function ball.rebound(shift_ball_x, shift_ball_y)
    local min_shift = math.min(math.abs(shift_ball_x), math.abs(shift_ball_y))
    if math.abs(shift_ball_x) == min_shift then
        shift_ball_y = 0
    else
        shift_ball_x = 0
    end
    ball.x = ball.x + shift_ball_x
    ball.y = ball.y + shift_ball_y
    if shift_ball_x ~= 0 then
        ball.speed_x = -ball.speed_x
    end
    if shift_ball_y ~= 0 then
        ball.speed_y = -ball.speed_y
    end
end


function ball.reposition()
    ball.x = 200
    ball.y = 500
end


local platform = {}
platform.x = 500
platform.y = 500
platform.width = 70
platform.height = 20
platform.speed_x = 500

function platform.draw()
    love.graphics.rectangle('line', platform.x, platform.y, platform.width, platform.height)
end

function platform.update(dt)
    if love.keyboard.isDown('right', 'd') then
        platform.x = platform.x + platform.speed_x * dt
    end

    if love.keyboard.isDown('left', 'a') then
        platform.x = platform.x - platform.speed_x * dt
    end
end

function platform.bounce_from_wall(shift_platform_x, shift_platform_y)
    platform.x = platform.x + shift_platform_x
end


local bricks = {}
bricks.x = 70
bricks.y = 50
bricks.width = 50
bricks.height = 30
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.current_level_bricks = {}

function bricks.construct_level(level_bricks_arrangement)
    for row_index, row in ipairs(level_bricks_arrangement) do
        for col_index, brick_type in ipairs(row) do
            if brick_type ~= 0 then
                local new_brick_x = bricks.x +
                    (col_index - 1) * (bricks.width + bricks.horizontal_distance)
                local new_brick_y = bricks.y +
                    (row_index - 1) * (bricks.height + bricks.vertical_distance)
                local new_brick = bricks.new_brick(new_brick_x, new_brick_y)
                bricks.add_to_current_level(new_brick)
            end
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

function bricks.brick_hit_by_ball(idx, brick, shift_ball_x, shift_ball_y)
    table.remove(bricks.current_level_bricks, idx)
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
    overlap, shift_ball_x, shift_ball_y = collisions.check_rectangle_overlap(
        platform, ball.bounding_rectangle()
    )
    if overlap then
        ball.rebound(shift_ball_x, shift_ball_y)
    end
end

function collisions.ball_bricks_collision(ball, bricks)
    ball_bounding_rectange = ball.bounding_rectangle()
    for idx, brick in pairs(bricks.current_level_bricks) do
        overlap, shift_ball_x, shift_ball_y =  collisions.check_rectangle_overlap(
            brick, ball_bounding_rectange)
        if overlap then
            ball.rebound(shift_ball_x, shift_ball_y)
            bricks.brick_hit_by_ball(idx, brick, shift_ball_x, shift_ball_y)
        end
    end
end

function collisions.ball_walls_collision(ball, walls)
    ball_bounding_rectange = ball.bounding_rectangle()
    local overlap, shift_ball_x, shift_ball_y
    for _, wall in pairs(walls.current_level_walls) do
        overlap, shift_ball_x, shift_ball_y = collisions.check_rectangle_overlap(
            wall, ball_bounding_rectange
        )
        if overlap then
            ball.rebound(shift_ball_x, shift_ball_y)
        end
    end
end

function collisions.platform_walls_collision(platform, walls)
    local overlap, shift_platform_x, shift_platform_y
    for _, wall in pairs(walls.current_level_walls) do
        overlap, shift_platform_x, shift_platform_y = collisions.check_rectangle_overlap(
            wall, platform
        )
        if overlap then
            platform.bounce_from_wall(shift_platform_x, shift_platform_y)
        end
    end
end


local levels = {}

levels.sequence = {}
levels.sequence[1] = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1 },
   { 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1 },
   { 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0 },
   { 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0 },
   { 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

levels.sequence[2] = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1 },
   { 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0 },
   { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0 },
   { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0 },
   { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

levels.current_level = 0
levels.game_finished = false

function levels.switch_to_next_level(bricks)
    if #bricks.current_level_bricks == 0 then
        if levels.current_level < #levels.sequence then
            levels.current_level = levels.current_level + 1
            bricks.construct_level(levels.sequence[levels.current_level])
            ball.reposition()
        else
            levels.game_finished = true
        end
    end
end


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
    collisions.resolve_collisions()
    levels.switch_to_next_level(bricks)
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