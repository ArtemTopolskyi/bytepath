Object = require "lib/classic";

Input = require "lib/input";
Timer = require "lib/timer";
SceneManager = require "core/SceneManager";
Scene = require "core/Scene";
Area = require "core/Area";
GameObject = require "core/GameObject";

require "lib/utils";


local scene_manager;

function love.load()
  scene_manager = SceneManager();
end

function love.update(dt)
  scene_manager:update(dt);
end

function love.draw()
  scene_manager:draw();
end
