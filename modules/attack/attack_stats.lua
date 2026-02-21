local ATTACK_TYPE = require "modules.attack.attack_type";

local attack_stats = {
  [ATTACK_TYPE.NEUTRAL] = {
    cooldown = 0.24,
    color = COLOR.DEFAULT,
    ammo_consumption = 0,
    abbreviation = 'N',
  },
}

return attack_stats;
