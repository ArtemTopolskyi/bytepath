
local InfoText = require "objects/InfoText";
local HealthResourcePickUpEffect = require "objects/resources/HealthResource/HealthResourcePickUpEffect";

local HealthResource = GameObject:extend();

function HealthResource:new(area, x, y, options)
  HealthResource.super.new(self, area, 'HealthResource', x, y, options);

  local screen_side_multiplier = ({ -1, 1 })[math.random(2)];

  self.x = GAME_WIDTH / 2 + (screen_side_multiplier * (GAME_WIDTH / 2 + 48));
  self.y = utils.random_float(48, GAME_HEIGHT - 48);

  self.width, self.height = 10, 10;
  self.horizontal_velocity = -screen_side_multiplier * utils.random_float(20, 40);

  self:add_collider();

  self.body:setLinearVelocity(self.horizontal_velocity, 0);
end

function HealthResource:update(dt)
  HealthResource.super.update(self, dt);
end

function HealthResource:draw()
  local rect_length = self.width;
  local rect_width = self.width / 3;

  love.graphics.setColor(COLOR.HEALTH);
  love.graphics.rectangle('fill', self.x - rect_length / 2, self.y - rect_width / 2, rect_length, rect_width);
  love.graphics.rectangle('fill', self.x - rect_width / 2, self.y - rect_length / 2, rect_width, rect_length);

  love.graphics.setColor(COLOR.DEFAULT);
  love.graphics.circle('line', self.x, self.y, self.width);
end

function HealthResource:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newCircleShape(self.width);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.PICKUP);
  self:setCollisionMasks(COLLISION_LAYER.PLAYER);
end

function HealthResource:onCollisionEnter(other)
  if other.label ~= 'Player' then return end;

  other:add_health(25);

  self.dead = true;

  self.area:add_game_object(
    InfoText(
      self.area,
      self.x + utils.random_float(-16, 16),
      self.y + utils.random_float(-16, 16),
      { text = "+HP", color = COLOR.HEALTH }
    )
  );
  self.area:add_game_object(HealthResourcePickUpEffect(self.area, self.x, self.y, { width = self.width, height = self.height }));
end

return HealthResource;
