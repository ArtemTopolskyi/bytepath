local InfoText = GameObject:extend();

function InfoText:new(area, x, y, options)
  InfoText.super.new(self, area, 'InfoText', x, y, options);

  self.depth = 30;
  self.font = fonts.m5x7_16;

  self.characters = self:text_to_characters(options.text or "");
end

function InfoText:update(dt)
  InfoText.super.update(self, dt);
end

function InfoText:draw()
  love.graphics.setColor(COLOR.DEFAULT);
  love.graphics.setFont(self.font);
  love.graphics.print(self.text, math.floor(self.x), math.floor(self.y));
end

function InfoText:text_to_characters(text)
  local characters = {};
  for i = 1, #text do table.insert(characters, text:sub(i, i)) end;

  return characters;
end

return InfoText;
