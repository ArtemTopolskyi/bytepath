local AmmoResourceDeathEffect = require "objects/resources/AmmoResource/AmmoResourceDeathEffect";

local AmmoResource = GameObject:extend();

function AmmoResource:new(area, x, y, options)
  AmmoResource.super.new(self, area, 'AmmoResource', x, y, options);

  self.width, self.height = 8, 8;
  self.direction = utils.random(0, 2 * math.pi);
  self.velocity = utils.random(10, 20);

  self:add_collider();

  self.body:applyAngularImpulse(utils.random(-8, 8));
  self.body:setLinearVelocity(
    self.velocity * math.cos(self.direction),
    self.velocity * math.sin(self.direction)
  );
end

function AmmoResource:update(dt)
  AmmoResource.super.update(self, dt);
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
  if other.label == 'Player' then
    self.dead = true;

    local death_effect = AmmoResourceDeathEffect(
      self.area,
      self.x,
      self.y,
      { width = self.width * 1.2, height = self.height * 1.2, color = COLOR.AMMO }
    );

    self.area:add_game_object(death_effect);
  end
end

return AmmoResource;
