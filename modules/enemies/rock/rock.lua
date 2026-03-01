local COLOR = require("modules.ui.color");
local COLLISION_LAYER = require("modules.physics.collision_layer");

local Rock = GameObject:extend();

function Rock:new(area, x, y, options)
  Rock.super.new(self, area, 'Rock', x, y, options);

  local direction = ({ -1, 1 })[math.random(2)];
  self.x = GAME_WIDTH / 2 + (-direction * (GAME_WIDTH / 2 + 48));
  self.y = utils.random_float(16, GAME_HEIGHT - 16);

  self.w, self.h = 8, 8;
  self.velocity = direction * utils.random_float(20, 40);

  self:add_collider();

  self.body:setLinearVelocity(self.velocity, 0);
  self.body:applyAngularImpulse(utils.random_float(-50, 50));
end

function Rock:update(dt)
  Rock.super.update(self, dt);
end

function Rock:draw()
  love.graphics.setColor(COLOR.HEALTH);
  love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()));
end

function Rock:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newPolygonShape(unpack(self:create_irregular_polygon(self.w, 8)));
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);

  self:setCollisionLayers(COLLISION_LAYER.ENEMY);
  self:setCollisionMasks(COLLISION_LAYER.PLAYER, COLLISION_LAYER.PROJECTILE);
end

function Rock:create_irregular_polygon(size, points_count)
  local points_count = points_count or 8;
  local points = {};

  for i = 1, points_count do
    local angle_interval = 2 * math.pi / points_count;
    local distance = size + utils.random_float(-size / 4, size / 4);
    local angle = (i - 1) * angle_interval + utils.random_float(-angle_interval / 4, angle_interval / 4);

    table.insert(points, distance * math.cos(angle));
    table.insert(points, distance * math.sin(angle));
  end

  return points;
end

return Rock;
