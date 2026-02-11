local ExplodeParticle = require "objects/effects/ExplodeParticle";
local AmmoResourceDeathEffect = require "objects/resources/AmmoResource/AmmoResourceDeathEffect";

local AmmoResource = GameObject:extend();

function AmmoResource:new(area, x, y, options)
  AmmoResource.super.new(self, area, 'AmmoResource', x, y, options);

  self.width, self.height = 7.5, 7.5;
  self.direction = utils.random_float(0, 2 * math.pi);
  self.velocity = utils.random_float(10, 20);

  self:add_collider();

  self.body:applyAngularImpulse(utils.random_float(-8, 8));
  self.body:setLinearVelocity(
    self.velocity * math.cos(self.direction),
    self.velocity * math.sin(self.direction)
  );
end

function AmmoResource:update(dt)
  AmmoResource.super.update(self, dt);

  local player = self.area.scene.player;

  if not player then return end;

  local current_heading = Vector(self.body:getLinearVelocity()):normalized();
  local dx, dy = player.x - self.x, player.y - self.y;
  local to_target = Vector(dx, dy):normalized();
  local final_heading = (current_heading + 0.1 * to_target):normalized();

  self.body:setLinearVelocity(self.velocity * final_heading.x, self.velocity * final_heading.y)
end

function AmmoResource:draw()
  utils.push_rotate(self.x, self.y, self.body:getAngle());

  love.graphics.setColor(COLOR.AMMO);
  love.graphics.rectangle('line', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height);

  love.graphics.pop();
end

function AmmoResource:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newRectangleShape(self.width, self.height);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.PICKUP);
  self:setCollisionMasks(COLLISION_LAYER.PLAYER);
end

function AmmoResource:onCollisionEnter(other)
  if other.label == 'Player' then self:handle_collision_with_player(other) end;
end

function AmmoResource:handle_collision_with_player(player)
  player:add_ammo(5);

  self.dead = true;

  local death_effect = AmmoResourceDeathEffect(
    self.area,
    self.x,
    self.y,
    { width = self.width, height = self.height, color = COLOR.AMMO }
  );

  self.area:add_game_object(death_effect);

  for _ = 1, love.math.random(6, 8) do
    self.area:add_game_object(
      ExplodeParticle(
        self.area,
        self.x,
        self.y,
        {
          color = COLOR.AMMO,
          duration = utils.random_float(0.3, 0.35),
          velocity = utils.random_float(50, 75)
        }
      )
    );
  end
end

return AmmoResource;
