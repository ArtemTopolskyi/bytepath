local ProjectileDeathEffect = GameObject:extend();

local DEATH_EFFECT_STAGE = {
  FIRST = 0,
  SECOND = 1,
}

function ProjectileDeathEffect:new(area, x, y, options)
  ProjectileDeathEffect.super.new(self, area, 'ProjectileDeathEffect', x, y, options);

  self.width = options.width or 7.5;
  self.height = options.height or 7.5;

  self.stage = DEATH_EFFECT_STAGE.FIRST;

  self.timer:after(0.1, function()
    self.stage = DEATH_EFFECT_STAGE.SECOND;
    self.timer:after(0.15, function() self.dead = true end)
  end);
end

function ProjectileDeathEffect:draw()
  if self.stage == DEATH_EFFECT_STAGE.FIRST then
    love.graphics.setColor(COLOR.DEFAULT);
    love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height);

    return;
  end

  if self.stage == DEATH_EFFECT_STAGE.SECOND then
    love.graphics.setColor(COLOR.HEALTH);
    love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height);

    return;
  end
end

return ProjectileDeathEffect;
