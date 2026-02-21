local COLOR = require "modules.ui.color";

local AmmoResourceDeathEffect = GameObject:extend();

local DEATH_EFFECT_STAGE = {
  FIRST = 0,
  SECOND = 1,
}

function AmmoResourceDeathEffect:new(area, x, y, options)
  AmmoResourceDeathEffect.super.new(self, area, 'AmmoResourceDeathEffect', x, y, options);

  self.width = options.width or 7.5;
  self.height = options.height or 7.5;
  self.color = options.color or COLOR.AMMO;
  self.depth = 15;

  self.stage = DEATH_EFFECT_STAGE.FIRST;

  self.timer:after(0.1, function ()
    self.stage = DEATH_EFFECT_STAGE.SECOND;
    self.timer:after(0.15, function() self.dead = true end);
  end);
end

function AmmoResourceDeathEffect:update(dt)
  AmmoResourceDeathEffect.super.update(self, dt);
end

function AmmoResourceDeathEffect:draw()
  utils.push_rotate(self.x, self.y, math.pi / 4);

  local color = self.stage == DEATH_EFFECT_STAGE.FIRST and COLOR.DEFAULT or self.color;

  love.graphics.setColor(color);
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height);

  love.graphics.pop();
end

return AmmoResourceDeathEffect;
