local AbilityTickEffect = GameObject:extend();

function AbilityTickEffect:new(area, x, y, options)
  AbilityTickEffect.super.new(self, area, 'AbilityTickEffect', x, y, options);

  self.width, self.initial_height = 48, 32;
  self.height = self.initial_height;
  self.depth = 25;

  self.timer:tween(0.13, self, { height = 0 }, 'in-out-cubic', function() self.dead = true end);
end

function AbilityTickEffect:update(dt)
  AbilityTickEffect.super.update(self, dt);

  if self.parent then self.x, self.y = self.parent.x, self.parent.y end;
end

function AbilityTickEffect:draw()
  love.graphics.setColor(COLOR.DEFAULT);
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.initial_height / 2, self.width, self.height);
end

return AbilityTickEffect;
