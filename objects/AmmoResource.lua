local AmmoResource = GameObject:extend();

function AmmoResource:new(area, x, y, options)
  AmmoResource.super.new(self, area, 'AmmoResource', x, y, options);

  self.width, self.height = 8, 8;
  self.rotation = utils.random(0, 2 * math.pi);
  self.velocity = utils.random(10, 20);

  self:add_collider();
end

function AmmoResource:update(dt)
  AmmoResource.super.update(self, dt);
end

function AmmoResource:draw()
  utils.push_rotate(self.x, self.y, self.rotation);

  love.graphics.setColor(COLOR.AMMO);
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height);

  love.graphics.pop();
end

function AmmoResource:add_collider()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newRectangleShape(self.width, self.height);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);
end

return AmmoResource;
