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

return ball