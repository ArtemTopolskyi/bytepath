local Player = require "objects/Player";

local Stage = Object:extend();

function Stage:new()
  self.area = Area(self);
  self.area:add_physics_world();

  self.main_canvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT);
  self.camera = Camera(GAME_WIDTH / 2, GAME_HEIGHT / 2);

  self.player = Player(self.area, GAME_WIDTH / 2, GAME_HEIGHT / 2);

  self.area:add_game_object(self.player);
end

function Stage:update(dt)
  self.area:update(dt);
end

function Stage:draw()
  love.graphics.setCanvas(self.main_canvas);
  love.graphics.clear();

  self.camera:attach(0, 0, GAME_WIDTH, GAME_HEIGHT);
  love.graphics.circle('line', GAME_WIDTH / 2, GAME_HEIGHT / 2, 250);
  self.area:draw();
  self.camera:detach();

  love.graphics.setCanvas();

  love.graphics.setColor(255, 255, 255, 255);
  love.graphics.setBlendMode('alpha', 'premultiplied');
  love.graphics.draw(self.main_canvas, 0, 0, 0, SCALE_X, SCALE_Y);
  love.graphics.setBlendMode('alpha');
end

function Stage:destroy()
  self.area:destroy();
  self.area = nil;
  self.player = nil;
  self.main_canvas = nil;
  self.camera = nil;
end

return Stage;
