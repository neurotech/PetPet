Elements.Text.CreateFreeText = function(fontPath, name, parent, text, size)
  size = size or 12

  local textElement = parent:CreateFontString(name, "ARTWORK")

  textElement:SetIgnoreParentScale(true)
  textElement:SetFont(fontPath, size)
  textElement:SetTextColor(1, 1, 1)
  textElement:SetShadowColor(0, 0, 0, 0.85)
  textElement:SetShadowOffset(1, -1)
  textElement:SetText(text)

  return textElement
end

Elements.Text.CreateText = function(
  fontPath,
  name,
  frame,
  anchorPoint,
  relativePoint,
  text,
  size,
  offsetX,
  offsetY,
  point
)
  point = point or "TOPLEFT"
  relativePoint = relativePoint or "TOPLEFT"
  size = size or 12
  offsetX = offsetX or Elements.Units.Padding
  offsetY = offsetY or 0

  local textFrame = Elements.Common.CreateFrameBlock(frame)
  textFrame:SetPoint("TOPLEFT", anchorPoint, relativePoint, 0, offsetY)

  local textElement = Elements.Text.CreateFreeText(fontPath, name, textFrame, text, size)

  local textFrameHeight = size

  if textElement:GetStringHeight() > 0 then
    textFrameHeight = textElement:GetStringHeight()
  end

  textFrame:SetSize(frame:GetWidth(), textFrameHeight + (Elements.Units.Padding * 2))
  textElement:SetPoint(point, textFrame, offsetX, -Elements.Units.Padding)

  return textFrame, textElement
end

Elements.Text.CreateSeparator = function(name, panel, parent, relativePoint, blockHeight)
  relativePoint = relativePoint or "TOPLEFT"
  blockHeight = blockHeight or Elements.Units.Padding

  local frameBlock = Elements.Common.CreateFrameBlock(panel)
  frameBlock:SetPoint("TOPLEFT", parent, relativePoint)
  frameBlock:SetSize(panel:GetWidth(), blockHeight)

  local separator = CreateFrame("Frame", name, frameBlock, BackdropTemplateMixin and "BackdropTemplate")

  separator:SetPoint("CENTER", frameBlock, "BOTTOM")
  separator:SetSize((panel:GetWidth() - (Elements.Units.Padding * 2)), 1)
  separator:SetBackdrop({ bgFile = Elements.Textures.PANEL_BG_TEXTURE })
  separator:SetBackdropColor(
    Elements.Palette.RGB.BLACK[1],
    Elements.Palette.RGB.BLACK[2],
    Elements.Palette.RGB.BLACK[3]
  )

  return frameBlock
end

Elements.Text.RainbowText = function(text, palette)
  palette = palette or {
    "9B5DE5",
    "F15BB5",
    "FEE440",
    "00BBF9",
    "00F5D4"
  }
  local rainbowText = ""
  local paletteIndex = 1

  for char in text:gmatch(".") do
    if paletteIndex > #palette then
      paletteIndex = 1
    end

    rainbowText = rainbowText .. palette[paletteIndex] .. char .. Elements.Palette.RESET

    paletteIndex = paletteIndex + 1
  end

  return rainbowText
end
