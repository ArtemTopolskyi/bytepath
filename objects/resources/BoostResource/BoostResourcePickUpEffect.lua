local COLOR = require "modules.ui.color";

local BoostResourcePickUpEffect = GameObject:extend();

local EFFECT_STAGE = {
  FIRST = 0,
  SECOND = 1,
}

local COLOR_BY_STAGE = {
  [EFFECT_STAGE.FIRST] = COLOR.DEFAULT,
  [EFFECT_STAGE.SECOND] = COLOR.BOOST,
}

function BoostResourcePickUpEffect:new(area, x, y, options)
  BoostResourcePickUpEffect.super.new(self, area, 'BoostResourcePickUpEffect', x, y, options);

  self.width = options.width or 12;
  self.height = options.height or 12;
  self.depth = 15;

  self.is_visible = true;
  self.stage = EFFECT_STAGE.FIRST;

  self.inner_rectangle_size_multiplier = 1.34;
  self.outer_rectangle_size_multiplier = 2;

  self.timer:tween(0.35, self, { outer_rectangle_size_multiplier = 4 }, 'in-out-cubic');

  self.timer:after(0.2, function()
    self.stage = EFFECT_STAGE.SECOND;

    self.timer:every(0.05, function() self.is_visible = not self.is_visible end, 6);
    self.timer:after(0.35, function() self.dead = true end);
  end)
end

function BoostResourcePickUpEffect:update(dt)
  BoostResourcePickUpEffect.super.update(self, dt);
end

function BoostResourcePickUpEffect:draw()
  if not self.is_visible then return end;

  love.graphics.setColor(COLOR_BY_STAGE[self.stage]);

  self:draw_inner_rectangle();
  self:draw_outer_rectangle();
end

function BoostResourcePickUpEffect:draw_inner_rectangle()
  shapes.rhombus(
    'fill',
    self.x,
    self.y,
    self.width * self.inner_rectangle_size_multiplier,
    self.height * self.inner_rectangle_size_multiplier
  );
end

function BoostResourcePickUpEffect:draw_outer_rectangle()
  shapes.rhombus(
    'line',
    self.x,
    self.y,
    self.width * self.outer_rectangle_size_multiplier,
    self.height * self.outer_rectangle_size_multiplier
  );
end

return BoostResourcePickUpEffect;
