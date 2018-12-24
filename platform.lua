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

return platform