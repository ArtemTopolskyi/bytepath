local COLOR = require "modules.ui.color";

local ShipMesh = GameObject:extend();

function ShipMesh:new(area, x, y, options)
  ShipMesh.super.new(self, area, 'ShipSprite', x, y, options);

  self.size = options.size or 12;
  self.parent = options.parent;

  self.local_polygons = self:get_polygons();
  self.world_polygons = self:get_polygons();
end

function ShipMesh:update(dt)
  ShipMesh.super.update(self, dt);

  if self.parent then
    self:transform_to_world_polygons(self.parent.x, self.parent.y);
  end
end

function ShipMesh:draw()
  utils.push_rotate(self.parent.x, self.parent.y, self.parent.rotation);
  love.graphics.setColor(COLOR.DEFAULT);

  for _, polygon in ipairs(self.world_polygons) do
    love.graphics.polygon('line', polygon);
  end

  love.graphics.pop();
end

function ShipMesh:transform_to_world_polygons(x_offset, y_offset)
  for i = 1, #self.local_polygons do
    for j = 1, #self.local_polygons[i], 2 do
      self.world_polygons[i][j] = self.local_polygons[i][j] + x_offset;
      self.world_polygons[i][j + 1] = self.local_polygons[i][j + 1] + y_offset;
    end
  end
end

function ShipMesh:get_polygons()
  return {
    {
      self.size, 0,
      self.size / 2, -self.size / 2,
      -self.size / 2, -self.size / 2,
      -self.size, 0,
      -self.size / 2, self.size / 2,
      self.size / 2, self.size / 2,
    },
    {
      self.size / 2, -self.size / 2,
      0, -self.size,
      -self.size - self.size / 2, -self.size,
      -self.size * 3 / 4, -self.size / 4,
      -self.size / 2, -self.size / 2,
    },
    {
      self.size / 2, self.size / 2,
      -self.size / 2, self.size / 2,
      -self.size * 3 / 4, self.size / 4,
      -self.size - self.size / 2, self.size,
      0, self.size,
    }
  }
end

return ShipMesh;
