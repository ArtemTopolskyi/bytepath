local BoostResourcePickUpEffect = require "objects/resources/BoostResource/BoostResourcePickUpEffect";
local InfoText = require "objects/InfoText";

local BoostResource = GameObject:extend();

function BoostResource:new(area, x, y, options)
  BoostResource.super.new(self, area, 'BoostResource', x, y, options);

  local screen_side_multiplier = ({ -1, 1 })[math.random(2)];

  self.x = GAME_WIDTH / 2 + (screen_side_multiplier * (GAME_WIDTH / 2 + 48));
  self.y = utils.random_float(48, GAME_HEIGHT - 48);

  self.width, self.height = 12, 12;
  self.horizontal_velocity = -screen_side_multiplier * utils.random_float(20, 40);

  self:add_collider();

  self.body:setLinearVelocity(self.horizontal_velocity, 0);
  self.body:applyAngularImpulse(utils.random_float(-24, 24));
end

function BoostResource:update(dt)
  BoostResource.super.update(self, dt);
end

function BoostResource:draw()
  utils.push_rotate(self.x, self.y, self.body:getAngle());
  love.graphics.setColor(COLOR.BOOST);

  shapes.rhombus('fill', self.x, self.y, 0.5 * self.width, 0.5 * self.height);
  shapes.rhombus('line', self.x, self.y, 1.5 * self.width, 1.5 * self.height);

  love.graphics.pop();
end

function BoostResource:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newRectangleShape(self.width, self.height);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.PICKUP);
  self:setCollisionMasks(COLLISION_LAYER.PLAYER);
end

function BoostResource:onCollisionEnter(other)
  if other.label ~= 'Player' then return end;

  other:add_boost(5);

  self.dead = true;

  self.area:add_game_object(
    BoostResourcePickUpEffect(
      self.area, self.x, self.y, { width = self.width, height = self.height }
    )
  );

  self.area:add_game_object(InfoText(self.area, self.x, self.y, { text = "+BOOST" }));
end

return BoostResource;
