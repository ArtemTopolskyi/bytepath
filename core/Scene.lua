local Scene = Object:extend();

function Scene:new()
  self.area = Area(self);
end

function Scene:update(dt)
  self.area:update(dt);
end

function Scene:destroy()
  self.area:destroy();
  self.area = nil;
end

return Scene;
