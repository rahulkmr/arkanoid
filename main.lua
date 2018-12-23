local ball = {}
ball.x = 300
ball.y = 300
ball.radius = 10
ball.speed_x = 300
ball.speed_y = 300


local platform = {}
platform.x = 500
platform.y = 500
platform.width = 70
platform.height = 20
platform.speed_x = 300


local brick = {}
brick.x = 100
brick.y = 100
brick.width = 50
brick.height = 30


function love.load()

end


function love.update(dt)
    ball.x = ball.x + ball.speed * dt
    ball.y = ball.y + ball.speed * dt
    
    if love.keyboard.isDown('right') then
        platform.x = platform.x + platform.speed_x * dt
    end

    if love.keyboard.isDown('left') then
        platform.x = platform.x - platform.speed_x * dt
    end
end


function love.draw()
    local segments_in_circle = 16
    love.graphics.circle('line', ball.x, ball.y, ball.radius, segments_in_circle)
    love.graphics.rectangle('line', platform.x, platform.y, platform.width, platform.height)
    love.graphics.rectangle('line', brick.x, brick.y, brick.width, brick.height)
end


function love.quit()
    print('Thanks for playing! Come back soon!')
end