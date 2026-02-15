local rhombus = function(mode, x, y, width, height)
  local half_width, half_height = width / 2, height / 2
  local vertices = {
    x, y - half_height,
    x + half_width, y,
    x, y + half_height,
    x - half_width, y,
  }

  love.graphics.polygon(mode, vertices)
end

return {
  rhombus = rhombus,
}
