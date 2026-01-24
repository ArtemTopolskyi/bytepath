local Player = GameObject:extend();

local input;


function Player:move_camera_after_player()
  local camera = self.area.scene.camera;
  local dx, dy = self.x - camera.x, self.y - camera.y;

  camera:move(dx, dy);
end

function Player:new(area, x, y)
  self.super.new(self, area, 'Player', x, y);

  self.speed = 150;

  input = Input();
  input:bind('a', 'move_left');
  input:bind('d', 'move_right');
  input:bind('w', 'move_up');
  input:bind('s', 'move_down');
end

function Player:update(dt)
  self.super.update(self, dt);

  if input:down('move_left') then
    self.x = self.x - self.speed * dt;
  end

  if input:down('move_right') then
    self.x = self.x + self.speed * dt;
  end

  if input:down('move_down') then
    self.y = self.y + self.speed * dt;
  end

  if input:down('move_up') then
    self.y = self.y - self.speed * dt;
  end

  self:move_camera_after_player();
end

function Player:draw()
  love.graphics.setColor(1, 0, 0);
  love.graphics.circle('line', self.x, self.y, 10);
  love.graphics.setColor(1, 1, 1);
end

return Player;
