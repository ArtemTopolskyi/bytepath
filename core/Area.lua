local Area = Object:extend();

function Area:new(scene)
  self.scene = scene;
  self.game_objects = {};
end

function Area:add_game_object(game_object)
  table.insert(self.game_objects, game_object);

  return game_object;
end

function Area:update(dt)
  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i];

    game_object:update(dt);

    if game_object.dead then
      table.remove(self.game_objects, i);
    end
  end
end

function Area:draw()
  for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

return Area;
