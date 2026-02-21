local COLLISION_LAYER = require "modules.physics.collision_layer";

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

function GameObject:onCollisionEnter(other, my_fixture, other_fixture, contact)
end

function GameObject:onCollisionExit(other, my_fixture, other_fixture, contact)
end

function GameObject:setCollisionLayers(...)
  if not self.fixture then
    error("Cannot set collision layers: fixture does not exist");
  end

  self.fixture:setCategory(...);
end

--[[
  Love2D physics implementation uses an inverted logic for collision masks.
  Instead of specifying which layers the object should collide with, it specifies which layers the object should ignore.
  This setter sets the collision masks to the inverse of the layers specified.
  This way, a mask defines which layers the object should collide with.
]]--
function GameObject:setCollisionMasks(...)
  if not self.fixture then
    error("Cannot set collision masks: fixture does not exist");
  end

  local masks = {...};

  local all_layers = {};
  for _, layer_value in pairs(COLLISION_LAYER) do
    table.insert(all_layers, layer_value);
  end

  local masks_set = {};
  for _, layer in ipairs(masks) do
    masks_set[layer] = true;
  end

  local ignored_layers = {};
  for _, layer in ipairs(all_layers) do
    if not masks_set[layer] then
      table.insert(ignored_layers, layer);
    end
  end

  if #ignored_layers > 0 then
    self.fixture:setMask(unpack(ignored_layers));
  end
end

return GameObject;
