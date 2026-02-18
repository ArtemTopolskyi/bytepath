local InfoText = GameObject:extend();

function InfoText:new(area, x, y, options)
  InfoText.super.new(self, area, 'InfoText', x, y, options);

  self.visible = true;
  self.depth = 30;
  self.font = fonts.m5x7_16;

  self.characters = self:text_to_characters(options.text or "");

  self.timer:after(0.7, function()
    self.timer:every(0.05, function() self.visible = not self.visible end);
    self.timer:every(0.035, function() self:replace_random_character_with_random_symbol() end);
  end);
  self.timer:after(1.1, function() self.dead = true end);
end

function InfoText:update(dt)
  InfoText.super.update(self, dt);
end

function InfoText:draw()
  if not self.visible then return end;

  love.graphics.setFont(self.font);
  love.graphics.setColor(COLOR.DEFAULT);

  self:draw_characters();
end

function InfoText:text_to_characters(text)
  local characters = {};
  for i = 1, #text do table.insert(characters, text:sub(i, i)) end;

  return characters;
end

function InfoText:draw_characters()
  local current_x_offset = 0;

  for i = 1, #self.characters do
    love.graphics.print(
      self.characters[i],
      math.floor(self.x + current_x_offset),
      math.floor(self.y),
      0, -- orientation in radians
      1, -- scale x
      1, -- scale y
      1, -- origin offset x
      self.font:getHeight() / 2 -- origin offset y
    );

    current_x_offset = current_x_offset + self.font:getWidth(self.characters[i]);
  end
end

function InfoText:replace_random_character_with_random_symbol()
  local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ';

  for i = 1, #self.characters do
    if love.math.random(1, 20) == 1 then
      local random_character_index = love.math.random(1, #random_characters);

      self.characters[i] = utils.utf8sub(random_characters, random_character_index, random_character_index);
    end
  end
end

return InfoText;
