local ShootEffect = GameObject:extend();

function ShootEffect:new(area, x, y, options)
  ShootEffect.super.new(self, area, 'ShootEffect', x, y, options);

  self.width = 8;

  self.timer:tween(
    0.1,
    self,
    { width = 0 },
    'in-out-cubic',
    function() self.dead = true end
  );
end

function ShootEffect:update(dt)
  ShootEffect.super.update(self, dt);

  if self.player then
    self.x = self.player.x + self.offset * math.cos(self.player.rotation);
    self.y = self.player.y + self.offset * math.sin(self.player.rotation);
  end
end

function ShootEffect:draw()
  utils.push_rotate(self.x, self.y, self.player.rotation + math.pi / 4);
  love.graphics.rectangle(
    'fill',
    self.x - self.width / 2,
    self.y - self.width / 2,
    self.width,
    self.width
  );
  love.graphics.pop();
end

return ShootEffect;
