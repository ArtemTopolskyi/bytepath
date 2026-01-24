local Stage = Object:extend();

function Stage:new()
  self.area = Area(self);
  self.main_canvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT);
end

function Stage:update(dt)
  self.area:update(dt);
end

function Stage:draw()
  love.graphics.setCanvas(self.main_canvas);
  love.graphics.clear();
  love.graphics.circle('line', GAME_WIDTH / 2, GAME_HEIGHT / 2, 50);
  self.area:draw();
  love.graphics.setCanvas();

  love.graphics.setColor(255, 255, 255, 255);
  love.graphics.setBlendMode('alpha', 'premultiplied');
  love.graphics.draw(self.main_canvas, 0, 0, 0, SCALE_X, SCALE_Y);
  love.graphics.setBlendMode('alpha');
end

return Stage;
