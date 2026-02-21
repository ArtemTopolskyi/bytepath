local COLOR = require "modules.ui.color";
local ATTACK_TYPE = require "modules.attack.attack_type";

local attack_stats = {
  [ATTACK_TYPE.NEUTRAL] = {
    cooldown = 0.24,
    color = COLOR.DEFAULT,
    ammo_consumption = 0,
    abbreviation = 'N',
  },

  [ATTACK_TYPE.DOUBLE] = {
    cooldown = 0.32,
    color = COLOR.AMMO,
    ammo_consumption = 2,
    abbreviation = '2',
  },
}

return attack_stats;
