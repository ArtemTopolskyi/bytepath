local ExplodeParticle = GameObject:extend();

function ExplodeParticle:new(area, x, y, options)
  ExplodeParticle.super.new(self, area, 'ExplodeParticle', x, y, options);

  self.length = options.length or math.random(4, 6);
  self.width = 2;
  self.angle = utils.random_float(0, 2 * math.pi);
  self.velocity = options.velocity or math.random(75, 150);

  self.depth = 15;
  self.color = options.color or COLOR.DEFAULT;
  self.duration = options.duration or utils.random_float(0.3, 0.5);

  self.timer:tween(self.duration, self, { length = 0, width = 0 }, 'linear', function() self.dead = true end);
end

function ExplodeParticle:update(dt)
  ExplodeParticle.super.update(self, dt);

  self.x = self.x + self.velocity * math.cos(self.angle) * dt;
  self.y = self.y + self.velocity * math.sin(self.angle) * dt;
end

function ExplodeParticle:draw()
  utils.push_rotate(self.x, self.y, self.angle);

  love.graphics.setLineWidth(self.width);
  love.graphics.setColor(self.color);

  love.graphics.line(self.x - self.length / 2, self.y, self.x + self.length / 2, self.y);

  love.graphics.setLineWidth(1);
  love.graphics.pop();
end

return ExplodeParticle;
