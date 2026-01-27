local SceneManager = Object:extend();

function SceneManager:new()
  self.current_scene = nil;
  self.scenes = {};
end

function SceneManager:update(dt)
  if self.current_scene then
    self.current_scene:update(dt);
  end
end

function SceneManager:draw()
  if self.current_scene then
    self.current_scene:draw();
  end
end

function SceneManager:add_scene(name, scene)
  self.scenes[name] = scene;
end

function SceneManager:switch_scene(name, ...)
  if not self.scenes[name] then
    error("Scene " .. name .. " not found");
  end

  if self.current_scene and self.current_scene.destroy then
    self.current_scene:destroy();
  end

  self.current_scene = self.scenes[name](...);
end

return SceneManager;
