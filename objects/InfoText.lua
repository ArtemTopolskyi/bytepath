local InfoText = GameObject:extend();

function InfoText:new(area, x, y, options)
  InfoText.super.new(self, area, 'InfoText', x, y, options);

  self.depth = 80;

  self.characters = self.text_to_characters(options.text or "");
end

function InfoText:update(dt)
  InfoText.super.update(self, dt);
end

function InfoText:draw()
end

function InfoText:text_to_characters(text)
  for i = 1, #text do table.insert(self.characters, text:utf8sub(i, i)) end;
end

return InfoText;
