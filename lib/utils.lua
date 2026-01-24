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

local random = function(min, max)
  local min, max = min or 0, max or 1

  return (
    min > max
      and (love.math.random() * (min - max) + max)
      or (love.math.random() * (max - min) + min)
  );
end

return {
  uuid = uuid,
  squared_distance = squared_distance,
  random = random,
};
