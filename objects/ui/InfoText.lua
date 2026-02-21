local InfoText = GameObject:extend();

function InfoText:new(area, x, y, options)
  InfoText.super.new(self, area, 'InfoText', x, y, options);

  self.visible = true;
  self.depth = 30;
  self.font = fonts.m5x7_16;
  self.color = options.color or COLOR.DEFAULT;

  self.all_available_colors = self:generate_all_available_colors();

  self.cells = self:text_to_cells(options.text or "");

  self.timer:after(0.7, function()
    self.timer:every(0.05, function() self.visible = not self.visible end);
    self.timer:every(0.035, function() self:replace_cell_with_random_values() end);
  end);
  self.timer:after(1.1, function() self.dead = true end);
end

function InfoText:update(dt)
  InfoText.super.update(self, dt);
end

function InfoText:draw()
  if not self.visible then return end;

  love.graphics.setFont(self.font);

  self:draw_cells();
end

function InfoText:generate_all_available_colors()
  local colors = { COLOR.DEFAULT, COLOR.HEALTH, COLOR.AMMO, COLOR.BOOST, COLOR.SKILL_POINT };
  local inverted_colors = {};

  for i = 1, #colors do
    table.insert(
      inverted_colors,
      { 1 - colors[i][1], 1 - colors[i][2], 1 - colors[i][3], colors[i][4] }
    );
  end;

  return fn.append(colors, inverted_colors);
end;

function InfoText:text_to_cells(text)
  local cells = {};

  for i = 1, #text do
    table.insert(
      cells,
      {
        char = text:sub(i, i),
        foreground_color = self.color,
        background_color = COLOR.TRANSPARENT,
      }
    )
  end;

  return cells;
end

function InfoText:draw_cells()
  local current_x_offset = 0;

  for _, cell in ipairs(self.cells) do
    love.graphics.setColor(cell.background_color);
    love.graphics.rectangle(
      'fill',
      self.x + current_x_offset,
      self.y - self.font:getHeight() / 2,
      self.font:getWidth(cell.char),
      self.font:getHeight()
    );

    love.graphics.setColor(cell.foreground_color);
    love.graphics.print(
      cell.char,
      math.floor(self.x + current_x_offset),
      math.floor(self.y),
      0, -- orientation in radians
      1, -- scale x
      1, -- scale y
      0, -- origin offset x
      self.font:getHeight() / 2 -- origin offset y
    );

    current_x_offset = current_x_offset + self.font:getWidth(cell.char);
  end

  love.graphics.setColor(COLOR.DEFAULT);
end

function InfoText:replace_cell_with_random_values()
  local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ';

  for i = 1, #self.cells do
    if love.math.random(1, 20) == 1 then
      local random_character_index = love.math.random(1, #random_characters);

      self.cells[i].char = utils.utf8sub(random_characters, random_character_index, random_character_index);
    end

    if love.math.random(1, 10) == 1 then
      local random_index = love.math.random(1, #self.all_available_colors);
      self.cells[i].background_color = self.all_available_colors[random_index];
    end

    if love.math.random(1, 10) == 1 then
      local random_index = love.math.random(1, #self.all_available_colors);
      self.cells[i].foreground_color = self.all_available_colors[random_index];
    end
  end
end

return InfoText;
