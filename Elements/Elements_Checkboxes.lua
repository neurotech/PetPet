local function SetTextureInside(parent, texture)
  local xOffset = 1
  local yOffset = 1
  texture:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -yOffset)
  texture:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -xOffset, yOffset)
end

local function ApplyCheckedTexture(checkbox)
  local checkboxCheckedTexture = checkbox:GetCheckedTexture()
  checkboxCheckedTexture:SetVertexColor(unpack(Elements.Palette.RGB.TEAL))
  SetTextureInside(checkbox, checkboxCheckedTexture)
end

local function ApplyNormalTexture(checkbox)
  local checkBoxNormalTexture = checkbox:GetNormalTexture()

  checkBoxNormalTexture:SetVertexColor(
    Elements.Palette.RGB.WHITE[1],
    Elements.Palette.RGB.WHITE[2],
    Elements.Palette.RGB.WHITE[3],
    0.1
  )
  SetTextureInside(checkbox, checkBoxNormalTexture)
end

Elements.Checkboxes.Create = function(labelText, parent, anchorPoint, relativePoint, offsetX, fontPath)
  relativePoint = relativePoint or "BOTTOMLEFT"
  offsetX = offsetX or Elements.Units.Padding * 1.5
  fontPath = fontPath or nil

  local checkbox = CreateFrame("CheckButton", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
  Elements.Utilities.SetPixelScaling(checkbox)
  local label = checkbox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")

  checkbox:SetSize(Elements.Units.CheckboxWidth, Elements.Units.CheckboxHeight)
  checkbox:SetPoint("TOPLEFT", anchorPoint, relativePoint, offsetX, -Elements.Units.Padding)
  checkbox:SetBackdrop(
    {
      edgeFile = Elements.Textures.EDGE_TEXTURE,
      edgeSize = 1
    }
  )
  checkbox:SetBackdropBorderColor(unpack(Elements.Palette.RGB.BLACK))
  checkbox:SetCheckedTexture(Elements.Textures.BUTTON_BG_TEXTURE)
  checkbox:SetNormalTexture(Elements.Textures.BUTTON_BG_TEXTURE)

  ApplyNormalTexture(checkbox)
  ApplyCheckedTexture(checkbox)

  label:SetPoint("LEFT", checkbox, "RIGHT", Elements.Units.Padding, 0)
  label:SetText(labelText)

  if fontPath then
    label:SetFont(fontPath, 12, "")
  end

  return checkbox, label
end
