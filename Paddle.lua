Paddle = Class {}

function Paddle:init(x,y)
  W,H = love.graphics.getDimensions()
  self.x = x
  self.y = y
  self.speed = 550
  self.dy = 0
  self.height = H/8
  self.width = 16
  self.cd = 0
end

function Paddle:update(dt)
    self.cd = self.cd + dt
    if self.dy < 0 then
      self.y = math.max(0, self.y + self.dy * dt)
    else
      self.y = math.min(H-self.height, self.y + self.dy * dt)
    end
end

function Paddle:think(Ball)
  if true then
    self.cd = 0
    if Ball.y < self.y + self.height/2 then
      self.dy = -self.speed
    elseif Ball.y > self.y - self.height/2 then
      self.dy = self.speed
    end
  else self.dy = 0
  end
end

function Paddle:render()
  g = love.graphics
  g.setColor(1,1,1)
  g.push()
  g.translate(self.x,self.y)
  g.rectangle('fill', 0, 0, self.width,self.height)
  g.pop()
end

return Paddle