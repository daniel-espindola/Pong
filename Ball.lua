Ball = Class{}
W,H = love.graphics.getDimensions()

function Ball:init(x, y, raio)
  self.x = x
  self.y = y
  self.r = raio
  self.color = {1,1,1}
  
  self.dx = love.math.random() > 0.5 and 550 or -550
  self.dy = (love.math.random()*200-100 ) *6.5 
end

function Ball:reset()
  self.x = W/2
  self.y = H/2
  self.dx = love.math.random() > 0.5 and 550 or -450
  self.dy = (love.math.random()*200-100 ) *7.5 
end

function Ball:collides(paddle)
  
  if self.x > paddle.x+16 or paddle.x > self.x + self.r then
    return false
  end
  
  if self.y > paddle.y + paddle.height or paddle.y > self.y + self.r then
    return false
  end
  
  return true
  
end
function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:render()
  g = love.graphics
  g.setColor(unpack(self.color))
  g.push()
  g.translate(self.x,self.y)
  g.circle('fill',0,0,self.r)
  g.pop()

end

return Ball