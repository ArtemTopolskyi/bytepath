local AmmoResourceDeathEffect = GameObject:extend();

function AmmoResourceDeathEffect:new(area, x, y, options)
  AmmoResourceDeathEffect.super.new(self, area, 'AmmoResourceDeathEffect', x, y, options);

  self.width = options.width or 8;
  self.height = options.height or 8;
  self.color = options.color or COLOR.AMMO;

  self.timer:after(0.25, function() self.dead = true end);
end

function AmmoResourceDeathEffect:update(dt)
  AmmoResourceDeathEffect.super.update(self, dt);
end

function AmmoResourceDeathEffect:draw()
  utils.push_rotate(self.x, self.y, math.pi / 4);

  love.graphics.setColor(self.color);
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height);

  love.graphics.pop();
end

return AmmoResourceDeathEffect;
