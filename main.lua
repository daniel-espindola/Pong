W,H = love.graphics.getDimensions()
local _player
local _enemy
local _ball
local _frames
Class = require 'class'
require 'Paddle'
require 'Ball'

function love.load ()
  tuts = {1,1,1}
  t = 0
  i = 1
  love.graphics.setDefaultFilter('nearest', 'nearest')
  titleFont = love.graphics.newFont('font.ttf',32)
  scoreFont = love.graphics.newFont('font.ttf',128)
  winner = ''
  _player = Paddle(W/15,H/10)
  _player.score = 0
  _enemy = Paddle(14*W/15,9*H/10-H/6)
  _enemy.score = 0
  _ball = Ball(W/2,H/2,10)
  _frames = 0
  gameState = 'start'
  ost = love.audio.newSource('ost.mp3','stream')
  ost:play()
  ost:setLooping(true)
  ost:setVolume(.05)
  sounds = {
  hit = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
  score = love.audio.newSource('sounds/score.wav', 'static'),
  wall = love.audio.newSource('sounds/wall_hit.wav', 'static'),
  }
  sounds.hit:setVolume(0.15)
  sounds.score:setVolume(.03)
  sounds.wall:setVolume(.15)
end

function love.update(dt)
  -- controles do player
  t = t + dt
  if _player.score == 10 then
    gameState = 'done'
    winner = 'Vitória!'
  elseif _enemy.score == 10 then
    gameState = 'done'
    winner = 'Derrota :('
  end
  
  if love.keyboard.isDown('down') then
    _player.dy = _player.speed
  elseif love.keyboard.isDown('up') then
    _player.dy = -_player.speed
  else
    _player.dy = 0
  end
  
  -- colisão com player
  
  if _ball:collides(_player) then
    _ball.dx = -_ball.dx * 1.05
    _ball.dy = _ball.dy * 1.03
    _ball.x = _player.x + _player.width + 4 
    
    if _ball.dy < 0 then
      _ball.dy = -(love.math.random()*150-75 ) *7.5
    else
      _ball.dy = (love.math.random()*150-75 ) *7.5
    end
    
    sounds.hit:play()
    _ball.color = {love.math.random()*.7+.3,love.math.random()*.7+.3,love.math.random()*.7+.3}
  end
  
  -- colisão com inimigo
  
  if _ball:collides(_enemy) then
    _ball.dx = -_ball.dx * 1.05
    
    _ball.dy = _ball.dy * 1.03
    _ball.x = _enemy.x - _enemy.width - 2
    
    if _ball.dy < 0 then
      _ball.dy = -(love.math.random()*100-50 ) *7.5
    else
      _ball.dy = (love.math.random()*100-50 ) *7.5 
    end
    sounds.hit:play()
  end
  
  -- colisão com as paredes
  
  if _ball.y + _ball.r >= H or _ball.y - _ball.r <= 0 then
    _ball.dy = -_ball.dy
    sounds.wall:play()
  end
  
  -- detecção de pontos
  if _ball.x+20 < 0 then
    _enemy.score = _enemy.score +1
    _ball:reset()
    sounds.score:play()
    gameState = 'start'
  end
  
  if _ball.x-20 > W then
    _player.score = _player.score +1
    _ball:reset()
    sounds.score:play()
    gameState = 'start'
  end
  
  _enemy:think(_ball)
  _player:update(dt)
  _enemy:update(dt)
  if gameState == 'play' then _ball:update(dt) end
  
  tuts = {((math.floor(11*t))%11)/10,((math.floor(7*t))%11)/10,((math.floor(13*t))%11)/10}
end

function love.draw()
  love.graphics.setColor(.3,1,.3)
  love.graphics.clear(0.156,0.176,0.203)
  love.graphics.print("FPS: " .. love.timer.getFPS(),10,10,0,1/6)
  
  -- title
  love.graphics.setColor(unpack(tuts))
  love.graphics.setFont(titleFont)
  love.graphics.printf('Pong            Pong', -10, 10, W, 'center')
  love.graphics.line(W/2,0,W/2,H)
  
  -- score
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(scoreFont)
  love.graphics.print(_player.score, W/2 - 170, H/9)
  love.graphics.print(_enemy.score, W/2 + 90, H/9)

  _ball:render()
  _player:render()
  _enemy:render()
end

function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    -- if we press enter during the start state of the game, we'll go into play mode
    -- during play mode, the ball will move in a random direction
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            -- ball's new reset method
            _ball:reset()
        end
    end
end