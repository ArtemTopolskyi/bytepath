local utf8 = require "utf8";

local uuid = function()
  local fn = function(x)
      local r = love.math.random(16) - 1
      r = (x == "x") and (r + 1) or (r % 4) + 9
      return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

local squared_distance = function(x1, y1, x2, y2)
  return (x1 - x2) ^ 2 + (y1 - y2) ^ 2;
end

local random_float = function(min, max)
  local min, max = min or 0, max or 1

  return (
    min > max
      and (love.math.random() * (min - max) + max)
      or (love.math.random() * (max - min) + min)
  );
end

local utf8sub = function(str, start_index, end_index)
  local start_byte_offset = utf8.offset(str, start_index);
  local end_byte_offset = utf8.offset(str, end_index + 1);

  if start_byte_offset and end_byte_offset then return string.sub(str, start_byte_offset, end_byte_offset - 1) end
  if start_byte_offset then return string.sub(str, start_byte_offset) end

  return ""
end

local push_rotate = function(x, y, r)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.translate(-x, -y)
end

local push_rotate_scale = function(x, y, r, sx, sy)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.scale(sx or 1, sy or 1)
  love.graphics.translate(-x, -y)
end

return {
  uuid = uuid,
  squared_distance = squared_distance,
  random_float = random_float,
  push_rotate = push_rotate,
  push_rotate_scale = push_rotate_scale,
  utf8sub = utf8sub,
};
