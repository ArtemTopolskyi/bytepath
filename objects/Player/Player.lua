local COLOR = require "modules.ui.color";
local COLLISION_LAYER = require "modules.physics.collision_layer";
local ShootEffect = require "objects/Player/ShootEffect";
local Projectile = require "objects/Projectile/Projectile";
local AbilityTickEffect = require "objects/Player/AbilityTickEffect";
local TrailParticle = require "objects/Player/TrailParticle";
local ShipMesh = require "content/ShipMesh";
local ATTACK_TYPE = require "modules.attack.attack_type";
local attack_stats = require "modules.attack.attack_stats";

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

  self.can_boost = true;
  self.max_boost_amount = 100;
  self.current_boost_amount = self.max_boost_amount;

  self.max_health = 100;
  self.health = self.max_health;

  self.attack_type = ATTACK_TYPE.NEUTRAL;
  self.attack_cooldown = attack_stats[self.attack_type].cooldown;
  self.attack_timer = 0;

  self.max_ammo = 100;
  self.ammo = self.max_ammo;

  self.ship_mesh = ShipMesh(area, x, y, { size = self.size, parent = self });

  self:set_attack_type(ATTACK_TYPE.NEUTRAL);

  self:add_collider();

  self.timer:every(1.0, function() self:ability_tick() end);
  self.timer:every(0.01, function() self:spawn_trail_particle() end);
end

function Player:update(dt)
  Player.super.update(self, dt);

  self:update_attack_timer(dt);

  self.current_boost_amount = math.min(self.current_boost_amount + 10 * dt, self.max_boost_amount);
  self.max_velocity = self.base_max_velocity;
  self.acceleration_mode = ACCELERATION_MODE.NONE;

  if G.input:down('left') then self.rotation = self.rotation - self.rotation_velocity * dt end;
  if G.input:down('right') then self.rotation = self.rotation + self.rotation_velocity * dt end;

  if G.input:down('up') and self.can_boost then
    self:consume_boost(dt);

    self.max_velocity = 1.5 * self.base_max_velocity;
    self.acceleration_mode = ACCELERATION_MODE.ACCELERATION
  end;

  if G.input:down('down') and self.can_boost then
    self:consume_boost(dt);

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

function Player:set_attack_type(attack_type)
  self.attack_type = attack_type;
  self.ammo = self.max_ammo;
  self.attack_cooldown = attack_stats[attack_type].cooldown;
end

function Player:update_attack_timer(dt)
  self.attack_timer = self.attack_timer + dt;

  if self.attack_timer >= self.attack_cooldown then
    self.attack_timer = 0;
    self:shoot();
  end
end

function Player:shoot()
  local offset = 1.2 * self.size;

  if self.attack_type == ATTACK_TYPE.NEUTRAL then
    self:shoot_neutral_attack();
  elseif self.attack_type == ATTACK_TYPE.DOUBLE then
    self:shoot_double_attack();
  end

  self.area:add_game_object(
    ShootEffect(
      self.area,
      self.x + offset * math.cos(self.rotation),
      self.y + offset * math.sin(self.rotation),
      { player = self, offset = offset }
    )
  );

  if self.ammo <= 0 then self:set_attack_type(ATTACK_TYPE.NEUTRAL) end
end

function Player:shoot_neutral_attack()
  local offset = 1.2 * self.size;

  self.area:add_game_object(
    Projectile(
      self.area,
      self.x + 1.5 * offset * math.cos(self.rotation),
      self.y + 1.5 * offset * math.sin(self.rotation),
      { direction = self.rotation }
    )
  );
end

function Player:shoot_double_attack()
  local double_attack_stats = attack_stats[ATTACK_TYPE.DOUBLE];
  local offset = 1.2 * self.size;

  self.ammo = math.max(self.ammo - double_attack_stats.ammo_consumption, 0);

  local top_projectile_direction = self.rotation + math.pi / 12;
  local bottom_projectile_direction = self.rotation - math.pi / 12;

  self.area:add_game_object(
    Projectile(
      self.area,
      self.x + 1.5 * offset * math.cos(top_projectile_direction),
      self.y + 1.5 * offset * math.sin(top_projectile_direction),
      { direction = top_projectile_direction, color = double_attack_stats.color }
    )
  );
  self.area:add_game_object(
    Projectile(
      self.area,
      self.x + 1.5 * offset * math.cos(bottom_projectile_direction),
      self.y + 1.5 * offset * math.sin(bottom_projectile_direction),
      { direction = bottom_projectile_direction, color = double_attack_stats.color }
    )
  );
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
      self.x - 0.9 * self.size * math.cos(self.rotation) + 0.2 * self.size * math.cos(self.rotation - math.pi/2),
      self.y - 0.9 * self.size * math.sin(self.rotation) + 0.2 * self.size * math.sin(self.rotation - math.pi/2),
      { color = trail_particle_color }
    )
  );

  self.area:add_game_object(
    TrailParticle(
      self.area,
      self.x - 0.9 * self.size * math.cos(self.rotation) - 0.2 * self.size * math.cos(self.rotation - math.pi/2),
      self.y - 0.9 * self.size * math.sin(self.rotation) - 0.2 * self.size * math.sin(self.rotation - math.pi/2),
      { color = trail_particle_color }
    )
  );
end

function Player:consume_boost(dt)
  self.current_boost_amount = self.current_boost_amount - 50 * dt;

  if self.current_boost_amount <= 0 then
    self.can_boost = false;

    self.timer:after(2.0, function() self.can_boost = true end);
  end
end

function Player:move_camera_after_player()
  local camera = self.area.scene.camera;
  local dx, dy = self.x - camera.x, self.y - camera.y;

  camera:move(dx, dy);
end

function Player:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newCircleShape(self.size / 2);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.PLAYER);
  self:setCollisionMasks(COLLISION_LAYER.PICKUP, COLLISION_LAYER.PROJECTILE);
end

function Player:add_ammo(amount)
  self.ammo = math.min(self.ammo + amount, self.max_ammo);
end

function Player:add_boost(amount)
  self.current_boost_amount = math.min(self.current_boost_amount + amount, self.max_boost_amount);
end

function Player:add_health(amount)
  self.health = math.min(self.health + amount, self.max_health);
end

return Player;
