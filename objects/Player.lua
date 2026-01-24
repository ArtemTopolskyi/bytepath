local Player = GameObject:extend();

function Player:new(area, x, y)
  self.super.new(self, area, 'Player', x, y);

  self.width, self.height = 12, 12;
  self.speed = 150;
  self.rotation = -math.pi / 2; -- rotated to the top in radians
  self.rotation_velocity = 1.66 * math.pi;
  self.velocity = 0;
  self.max_velocity = 150;
  self.acceleration = 100;

  self:add_to_physics_world();
end

function Player:update(dt)
  self.super.update(self, dt);

  if input:down('move_left') then self.rotation = self.rotation - self.rotation_velocity * dt end;
  if input:down('move_right') then self.rotation = self.rotation + self.rotation_velocity * dt end;

  self.velocity = math.min(self.velocity + self.acceleration * dt, self.max_velocity);

  self.body:setLinearVelocity(
    self.velocity * math.cos(self.rotation),
    self.velocity * math.sin(self.rotation)
  );

  self:move_camera_after_player();
end

function Player:draw()
  love.graphics.setColor(1, 0, 0);
  love.graphics.circle('line', self.x, self.y, 10);
  love.graphics.line(
    self.x,
    self.y,
    self.x + 2 * self.width * math.cos(self.rotation),
    self.y + 2 * self.width * math.sin(self.rotation)
  );
  love.graphics.setColor(1, 1, 1);
end

function Player:move_camera_after_player()
  local camera = self.area.scene.camera;
  local dx, dy = self.x - camera.x, self.y - camera.y;

  camera:move(dx, dy);
end

function Player:add_to_physics_world()
  self.body = love.physics.newBody(self.area.world, self.x, self.y, 'dynamic');
  self.shape = love.physics.newCircleShape(self.width / 2);
  self.fixture = love.physics.newFixture(self.body, self.shape);
  self.fixture:setUserData(self);
end

return Player;
