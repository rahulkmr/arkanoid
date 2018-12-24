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

return walls