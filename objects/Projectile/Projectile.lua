local ProjectileDeathEffect = require "objects/Projectile/ProjectileDeathEffect";

local Projectile = GameObject:extend();

function Projectile:new(area, x, y, options)
  Projectile.super.new(self, area, 'Projectile', x, y, options);

  self.radius = options.radius or 2.5;
  self.size = options.size or 2.5;
  self.velocity = options.velocity or 200;
  self.direction = options.direction or 0;

  self:add_collider();

  self.body:setLinearVelocity(
    self.velocity * math.cos(self.direction),
    self.velocity * math.sin(self.direction)
  );
end

function Projectile:update(dt)
  Projectile.super.update(self, dt);

  if self:is_out_of_screen() then self:die() end
end

function Projectile:draw()
  utils.push_rotate(self.x, self.y, Vector(self.body:getLinearVelocity()):angle());
  love.graphics.setLineWidth(self.size - self.size / 4); -- 3/4 of the size is the width of the line

  --[[
    and importantly, we draw one line from -2*self.s to the center and then another from the center to 2*self.s. 
    We do this because each attack will have different colors,
    and what we'll do is change the color of one those lines but not change the color of another.
  ]]
  love.graphics.setColor(COLOR.DEFAULT);
  love.graphics.line(self.x - self.size * 2, self.y, self.x, self.y);
  love.graphics.setColor(COLOR.HEALTH);
  love.graphics.line(self.x, self.y, self.x + self.size * 2, self.y);

  love.graphics.setLineWidth(1);
  love.graphics.pop();
end

function Projectile:is_out_of_screen()
  return (
    self.x < 0
      or self.x > GAME_WIDTH
      or self.y < 0
      or self.y > GAME_HEIGHT
  );
end

function Projectile:die()
  self.dead = true;

  self.area:add_game_object(
    ProjectileDeathEffect(
      self.area,
      self.x,
      self.y,
      { width = self.size * 3, height = self.size * 3 }
    )
  );
end

function Projectile:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newRectangleShape(self.size * 2, self.size - self.size / 4);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.PROJECTILE);
  self:setCollisionMasks(COLLISION_LAYER.PLAYER);
end

return Projectile;
