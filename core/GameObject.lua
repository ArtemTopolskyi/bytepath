local GameObject = Object:extend();

function GameObject:new(area, label, x, y, options)
  local options = options or {};
  if options then for key, value in ipairs(options) do self[key] = value end end

  self.area = area;
  self.label = label;
  self.x = x;
  self.y = y;
  self.id = utils.uuid();
  self.dead = false;
  self.timer = Timer();
end

function GameObject:update(dt)
  if self.timer then self.timer:update(dt) end
  if self.body then self.x, self.y = self.body:getPosition() end;
end

function GameObject:draw()
end

return GameObject;
