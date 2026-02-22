local ShootEffect = require "modules.player.shoot_effect";
local Projectile = require "objects/Projectile/Projectile";
local ATTACK_TYPE = require "modules.attack.attack_type";
local attack_stats = require "modules.attack.attack_stats";

local AttackModule = Object:extend();

function AttackModule:new(player)
  self.player = player;

  self.attack_type = ATTACK_TYPE.NEUTRAL;
  self.attack_cooldown = attack_stats[self.attack_type].cooldown;
  self.attack_timer = 0;

  self.max_ammo = 100;
  self.ammo = self.max_ammo;

  self:set_attack_type(ATTACK_TYPE.NEUTRAL);
end

function AttackModule:update(dt)
  self:update_attack_timer(dt);
end

function AttackModule:add_ammo(amount)
  self.ammo = math.min(self.ammo + amount, self.max_ammo);
end

function AttackModule:set_attack_type(attack_type)
  self.attack_type = attack_type;
  self.ammo = self.max_ammo;
  self.attack_cooldown = attack_stats[attack_type].cooldown;
end

function AttackModule:update_attack_timer(dt)
  self.attack_timer = self.attack_timer + dt;

  if self.attack_timer >= self.attack_cooldown then
    self.attack_timer = 0;
    self:shoot();
  end
end

function AttackModule:shoot()
  local offset = 1.2 * self.player.size;

  if self.attack_type == ATTACK_TYPE.NEUTRAL then
    self:shoot_neutral_attack();
  elseif self.attack_type == ATTACK_TYPE.DOUBLE then
    self:shoot_double_attack();
  end

  self.player.area:add_game_object(
    ShootEffect(
      self.player.area,
      self.player.x + offset * math.cos(self.player.rotation),
      self.player.y + offset * math.sin(self.player.rotation),
      { player = self.player, offset = offset }
    )
  );

  if self.ammo <= 0 then self:set_attack_type(ATTACK_TYPE.NEUTRAL) end
end

function AttackModule:shoot_neutral_attack()
  local offset = 1.2 * self.player.size;

  self.player.area:add_game_object(
    Projectile(
      self.player.area,
      self.player.x + 1.5 * offset * math.cos(self.player.rotation),
      self.player.y + 1.5 * offset * math.sin(self.player.rotation),
      { direction = self.player.rotation }
    )
  );
end

function AttackModule:shoot_double_attack()
  local double_attack_stats = attack_stats[ATTACK_TYPE.DOUBLE];
  local offset = 1.2 * self.player.size;

  self.ammo = math.max(self.ammo - double_attack_stats.ammo_consumption, 0);

  local top_projectile_direction = self.player.rotation + math.pi / 12;
  local bottom_projectile_direction = self.player.rotation - math.pi / 12;

  self.player.area:add_game_object(
    Projectile(
      self.player.area,
      self.player.x + 1.5 * offset * math.cos(top_projectile_direction),
      self.player.y + 1.5 * offset * math.sin(top_projectile_direction),
      { direction = top_projectile_direction, color = double_attack_stats.color }
    )
  );
  self.player.area:add_game_object(
    Projectile(
      self.player.area,
      self.player.x + 1.5 * offset * math.cos(bottom_projectile_direction),
      self.player.y + 1.5 * offset * math.sin(bottom_projectile_direction),
      { direction = bottom_projectile_direction, color = double_attack_stats.color }
    )
  );
end

return AttackModule;
