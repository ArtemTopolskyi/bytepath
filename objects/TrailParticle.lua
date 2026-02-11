local TrailParticle = GameObject:extend();

function TrailParticle:new(area, x, y, options)
  TrailParticle.super.new(self, area, 'TrailParticle', x, y, options);

  self.radius = options.radius or utils.random_float(2, 4);
  self.duration = options.duration or utils.random_float(0.15, 0.25);
  self.color = options.color or COLOR.SKILL_POINT;

  self.timer:tween(self.duration, self, { radius = 0 }, 'linear', function() self.dead = true end);
end

function TrailParticle:draw()
  love.graphics.setColor(self.color);
  love.graphics.circle('fill', self.x, self.y, self.radius);
end

return TrailParticle;
