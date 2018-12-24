local collisions = {}

function collisions.resolve_collisions(ball, platform, walls, bricks)
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

return collisions