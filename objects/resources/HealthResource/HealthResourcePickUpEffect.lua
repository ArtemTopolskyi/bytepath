local HealthResourcePickUpEffect = GameObject:extend();

local EFFECT_STAGE = {
  FIRST = 0,
  SECOND = 1,
}

local COLOR_BY_STAGE = {
  [EFFECT_STAGE.FIRST] = COLOR.DEFAULT,
  [EFFECT_STAGE.SECOND] = COLOR.HEALTH,
}

function HealthResourcePickUpEffect:new(area, x, y, options)
  HealthResourcePickUpEffect.super.new(self, area, 'HealthResourcePickUpEffect', x, y, options);

  self.width = options.width or 12;
  self.height = options.height or 12;
  self.depth = 15;

  self.is_visible = true;
  self.stage = EFFECT_STAGE.FIRST;

  self.cross_size_multiplier = 1;
  self.outer_circle_size_multiplier = 1;

  self.timer:tween(
    0.2,
    self,
    { outer_circle_size_multiplier = 1.67, cross_size_multiplier = 1.5 },
    'in-out-cubic',
    function()
      self.stage = EFFECT_STAGE.SECOND;

      self.timer:every(0.05, function() self.is_visible = not self.is_visible end, 4);
      self.timer:after(0.25, function() self.dead = true end);
    end
  );
end

function HealthResourcePickUpEffect:update(dt)
  HealthResourcePickUpEffect.super.update(self, dt);
end

function HealthResourcePickUpEffect:draw()
  if not self.is_visible then return end;

  local rect_length = self.width * self.cross_size_multiplier;
  local rect_width = self.width * self.cross_size_multiplier / 3;

  love.graphics.setColor(COLOR_BY_STAGE[self.stage]);
  love.graphics.rectangle('fill', self.x - rect_length / 2, self.y - rect_width / 2, rect_length, rect_width);
  love.graphics.rectangle('fill', self.x - rect_width / 2, self.y - rect_length / 2, rect_width, rect_length);

  love.graphics.setColor(COLOR.DEFAULT);
  love.graphics.circle('line', self.x, self.y, self.width * self.outer_circle_size_multiplier);
end

return HealthResourcePickUpEffect;
