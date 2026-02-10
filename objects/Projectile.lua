local ProjectileDeathEffect = require "objects/ProjectileDeathEffect";

local Projectile = GameObject:extend();

function Projectile:new(area, x, y, options)
  Projectile.super.new(self, area, 'Projectile', x, y, options);

  self.radius = options.radius or 2.5;
  self.velocity = options.velocity or 200;
  self.direction = options.direction or 0;

  self:add_to_physics_world();

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
  love.graphics.setColor(COLOR.DEFAULT);
  love.graphics.circle('line', self.x, self.y, self.radius);
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
      { width = self.radius * 3, height = self.radius * 3 }
    )
  );
end

function Projectile:add_to_physics_world()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newCircleShape(self.radius);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.PROJECTILE);
  self:setCollisionMasks(COLLISION_LAYER.PLAYER);
end

return Projectile;
