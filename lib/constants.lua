local COLOR = {
  DEFAULT = { love.math.colorFromBytes(222, 222, 222) },
  BACKGROUND = { love.math.colorFromBytes(16, 16, 16) },
  AMMO = { love.math.colorFromBytes(123, 200, 164) },
  BOOST = { love.math.colorFromBytes(76, 195, 217) },
  HEALTH = { love.math.colorFromBytes(241, 103, 69) },
  SKILL_POINT = { love.math.colorFromBytes(255, 198, 93) },
}

-- Available values: 1-16 inclusive
local COLLISION_LAYER = {
  PLAYER = 1,
  PROJECTILE = 2,
  PICKUP = 3,
}

return {
  COLOR = COLOR,
  COLLISION_LAYER = COLLISION_LAYER,
};
