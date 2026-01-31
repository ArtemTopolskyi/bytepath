local ShootEffect = require "objects/ShootEffect";
local Projectile = require "objects/Projectile";
local AbilityTickEffect = require "objects/AbilityTickEffect";
local TrailParticle = require "objects/TrailParticle";
local ShipMesh = require "content/ShipMesh";

local ACCELERATION_MODE = {
  NONE = 0,
  ACCELERATION = 1,
  DECELERATION = 2,
}

local Player = GameObject:extend();

function Player:new(area, x, y, options)
  Player.super.new(self, area, 'Player', x, y, options);

  self.size = 12;

  self.rotation = -math.pi / 2; -- rotated to the top in radians
  self.rotation_velocity = 1.66 * math.pi;

  self.velocity = 0;
  self.base_max_velocity = 150;
  self.max_velocity = self.base_max_velocity;
  self.acceleration = 100;
  self.acceleration_mode = ACCELERATION_MODE.NONE;

  self.fire_rate = 0.48;

  self.ship_mesh = ShipMesh(area, x, y, { size = self.size, parent = self });

  self:add_to_physics_world();

  self.timer:every(self.fire_rate, function()
    self:shoot();
  end)

  self.timer:every(1.0, function() self:ability_tick() end);
  self.timer:every(0.01, function() self:spawn_trail_particle() end);
end

function Player:update(dt)
  Player.super.update(self, dt);

  self.max_velocity = self.base_max_velocity;
  self.acceleration_mode = ACCELERATION_MODE.NONE;

  if G.input:down('left') then self.rotation = self.rotation - self.rotation_velocity * dt end;
  if G.input:down('right') then self.rotation = self.rotation + self.rotation_velocity * dt end;
  if G.input:down('up') then
    self.max_velocity = 1.5 * self.base_max_velocity;
    self.acceleration_mode = ACCELERATION_MODE.ACCELERATION
  end;
  if G.input:down('down') then
    self.max_velocity = 0.5 * self.base_max_velocity;
    self.acceleration_mode = ACCELERATION_MODE.DECELERATION
  end;

  self.velocity = math.min(self.velocity + self.acceleration * dt, self.max_velocity);

  self.body:setLinearVelocity(
    self.velocity * math.cos(self.rotation),
    self.velocity * math.sin(self.rotation)
  );

  self.ship_mesh:update(dt);
end

function Player:draw()
  self.ship_mesh:draw();
end

function Player:shoot()
  local offset = 1.2 * self.size;

  local shoot_effect = ShootEffect(
    self.area,
    self.x + offset * math.cos(self.rotation),
    self.y + offset * math.sin(self.rotation),
    { player = self, offset = offset }
  );

  local projectile = Projectile(
    self.area,
    self.x + 1.5 * offset * math.cos(self.rotation),
    self.y + 1.5 * offset * math.sin(self.rotation),
    { direction = self.rotation }
  );

  self.area:add_game_object(shoot_effect);
  self.area:add_game_object(projectile);
end

function Player:ability_tick()
  self.area:add_game_object(
    AbilityTickEffect(
      self.area,
      self.x,
      self.y,
      { parent = self }
    )
  );
end

function Player:spawn_trail_particle()
  local trail_particle_color = (
    self.acceleration_mode == ACCELERATION_MODE.NONE
      and COLOR.SKILL_POINT
      or COLOR.BOOST
  );

  self.area:add_game_object(
    TrailParticle(
      self.area,
      self.x - self.size * math.cos(self.rotation),
      self.y - self.size * math.sin(self.rotation),
      { color = trail_particle_color }
    )
  );
end

function Player:move_camera_after_player()
  local camera = self.area.scene.camera;
  local dx, dy = self.x - camera.x, self.y - camera.y;

  camera:move(dx, dy);
end

function Player:add_to_physics_world()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newCircleShape(self.size / 2);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);
end

return Player;
