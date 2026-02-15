Object = require "lib/classic";
Vector = require "lib/vector";

Input = require "lib/input";
Timer = require "lib/timer";
Camera = require "lib/camera";

SceneManager = require "core/SceneManager";
Scene = require "core/Scene";
Area = require "core/Area";
GameObject = require "core/GameObject";

local Constants = require "lib/constants";

COLOR = Constants.COLOR;
COLLISION_LAYER = Constants.COLLISION_LAYER;

fn = require "lib/functional";
utils = require "lib/utils";
shapes = require "lib/shapes";


local function init_input()
  local input = Input();

  input:bind('a', 'left');
  input:bind('d', 'right');
  input:bind('w', 'up');
  input:bind('s', 'down');

  return input;
end

local function init_scene_manager()
  local scene_manager = SceneManager();

  scene_manager:add_scene('Stage', require "scenes/Stage");

  return scene_manager;
end

function love.load()
  G = {
    input = init_input(),
    scene_manager = init_scene_manager(),
  }

  love.graphics.setDefaultFilter('nearest');
  love.graphics.setLineStyle('rough');

  love.window.setMode(GAME_WIDTH * SCALE_X, GAME_HEIGHT * SCALE_Y);

  G.scene_manager:switch_scene('Stage');
end

function love.update(dt)
  G.scene_manager:update(dt);
end

function love.draw()
  G.scene_manager:draw();
end
