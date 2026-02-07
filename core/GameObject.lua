local GameObject = Object:extend();

function GameObject:new(area, label, x, y, options)
  local options = options or {};

  if options then for key, value in pairs(options) do self[key] = value end end

  self.area = area;
  self.label = label;
  self.x = x;
  self.y = y;
  self.id = utils.uuid();
  self.dead = false;
  self.depth = 0;
  self.timer = Timer();
  self.creation_time = love.timer.getTime();
end

function GameObject:update(dt)
  if self.timer then self.timer:update(dt) end
  if self.body then self.x, self.y = self.body:getPosition() end;
end

function GameObject:draw()
end

function GameObject:destroy()
  if self.timer then
    self.timer:clear();
  end

  if self.fixture then
    self.fixture:setUserData(nil);
    self.fixture:destroy();
    self.fixture = nil;
  end

  if self.shape then
    self.shape:release();
    self.shape = nil;
  end

  if self.body then
    self.body:destroy();
    self.body = nil;
  end

  self.area = nil;
  self.timer = nil;
end

return GameObject;
