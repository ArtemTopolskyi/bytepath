Object = require "lib/classic";

Input = require "lib/input";
Timer = require "lib/timer";
Camera = require "lib/camera";

SceneManager = require "core/SceneManager";
Area = require "core/Area";
GameObject = require "core/GameObject";

fn = require "lib/functional";
utils = require "lib/utils";


local StageScene = require "scenes/Stage";

function love.load()
  input = Input();
  input:bind('a', 'move_left');
  input:bind('d', 'move_right');

  love.graphics.setDefaultFilter('nearest');
  love.graphics.setLineStyle('rough');

  love.window.setMode(GAME_WIDTH * SCALE_X, GAME_HEIGHT * SCALE_Y);

  scene_manager = SceneManager();

  scene_manager:add_scene('Stage', StageScene);
  scene_manager:switch_scene('Stage');
end

function love.update(dt)
  scene_manager:update(dt);
end

function love.draw()
  scene_manager:draw();
end
