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


return bricks