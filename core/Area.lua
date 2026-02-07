local Area = Object:extend();

function Area:new(scene)
  self.scene = scene;
  self.game_objects = {};

  self.time_scale = 1.0;
end

function Area:update(dt)
  if self.world then self.world:update(dt * self.time_scale) end;

  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i];

    game_object:update(dt * self.time_scale);

    if game_object.dead then
      game_object:destroy();
      table.remove(self.game_objects, i);
    end
  end
end

function Area:draw()
  table.sort(self.game_objects, function(a, b)
    if a.depth == b.depth then
      return a.creation_time < b.creation_time;
    end

    return a.depth < b.depth;
  end);

  for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

function Area:add_game_object(game_object)
  table.insert(self.game_objects, game_object);

  return game_object;
end

function Area:destroy()
  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i]

    game_object:destroy()
    table.remove(self.game_objects, i)
  end

  self.game_objects = {}

  if self.world then
    self.world:destroy()
    self.world = nil
  end
end

function Area:add_physics_world(x_gravity, y_gravity, can_sleep)
  self.world = love.physics.newWorld(x_gravity, y_gravity, can_sleep);
end

function Area:get_game_objects(filter_fn)
  if not filter_fn then return self.game_objects end;

  local game_objects = {};

  for _, current_game_object in ipairs(self.game_objects) do
    if filter_fn(current_game_object) then
      table.insert(game_objects, current_game_object)
    end
  end

  return game_objects;
end

function Area:query_circle_area(x, y, radius, labels)
  local queried_game_objects = {};

  local squared_radius = radius ^ 2;

  local filtered_game_objects = (
    #labels > 0
      and self:get_game_objects(function(game_object) return fn.contains(labels, game_object.label) end)
      or self.game_objects
  );

  for _, current_game_object in ipairs(filtered_game_objects) do
    local squared_distance_from_circle_center_to_object = utils.squared_distance(
      current_game_object.x, current_game_object.y, x, y
    );

    if squared_distance_from_circle_center_to_object <= squared_radius then
      table.insert(queried_game_objects, current_game_object);
    end
  end

  return queried_game_objects;
end

function Area:get_closest_object(x, y, radius, labels)
  local current_closest_object = nil;
  local smallest_squared_distance = math.maxinteger;

  local squared_radius = radius ^ 2;

  local filtered_game_objects = (
    #labels > 0
      and self:get_game_objects(function(game_object) return fn.contains(labels, game_object.label) end)
      or self.game_objects
  );

  for _, current_game_object in ipairs(filtered_game_objects) do
    local squared_distance_from_circle_center_to_object = utils.squared_distance(
      current_game_object.x, current_game_object.y, x, y
    );

    if (
      squared_distance_from_circle_center_to_object < smallest_squared_distance
        and squared_distance_from_circle_center_to_object < squared_radius
    ) then
      current_closest_object = current_game_object;
      smallest_squared_distance = squared_distance_from_circle_center_to_object;
    end
  end

  return current_closest_object;
end

return Area;
