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

local scene_manager;

local resize = function(scale)
  love.window.setMode(GAME_WIDTH * scale, GAME_HEIGHT * scale);
  SCALE_X = scale;
  SCALE_Y = scale;
end

function love.load()
  input = Input();
  input:bind('a', 'move_left');
  input:bind('d', 'move_right');

  love.graphics.setDefaultFilter('nearest');
  love.graphics.setLineStyle('rough');

  resize(3);

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
