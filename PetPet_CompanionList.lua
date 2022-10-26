local function ApplyFavouriteStyle(petIcon, petFrame, petNameText)
  petIcon:SetBackdropBorderColor(unpack(Elements.Palette.RGB.BRIGHT_YELLOW))

  petFrame:SetBackdropBorderColor(
    Elements.Palette.RGB.RICH_YELLOW[1],
    Elements.Palette.RGB.RICH_YELLOW[2],
    Elements.Palette.RGB.RICH_YELLOW[3],
    0.66
  )
  petFrame:SetBackdropColor(
    Elements.Palette.RGB.RICH_YELLOW[1],
    Elements.Palette.RGB.RICH_YELLOW[2],
    Elements.Palette.RGB.RICH_YELLOW[3],
    0.33
  )

  petNameText:SetTextColor(unpack(Elements.Palette.RGB.BRIGHT_YELLOW))
end

local function RemoveFavouriteStyle(petIcon, petFrame, petNameText)
  petIcon:SetBackdropBorderColor(unpack(Elements.Palette.RGB.BLACK))

  petFrame:SetBackdropBorderColor(unpack(Elements.Palette.RGB.DARK_GREY))
  petFrame:SetBackdropColor(
    Elements.Palette.RGB.DARK_GREY[1],
    Elements.Palette.RGB.DARK_GREY[2],
    Elements.Palette.RGB.DARK_GREY[3],
    0.25
  )

  petNameText:SetTextColor(unpack(Elements.Palette.RGB.LIGHT_GREY))
  petNameText:SetShadowColor(unpack(Elements.Palette.RGB.BLACK))
end

local function CreatePetItem(parent, petID, petName, offsetY, petIconPath, frameID)
  local petFrame
  local iconFrame
  local iconTexture
  local petNameText

  -- Pet Frame
  if _G["PETPET_COMPANION_LIST_PET_" .. frameID] then
    petFrame = _G["PETPET_COMPANION_LIST_PET_" .. frameID]
  else
    petFrame = CreateFrame("Button", "PETPET_COMPANION_LIST_PET_" .. frameID, parent,
      BackdropTemplateMixin and "BackdropTemplate")
    Elements.Utilities.SetPixelScaling(petFrame)
    petFrame:SetSize((parent:GetWidth() - (Elements.Units.Padding * 2)),
      32 + (Elements.Units.Padding))
    petFrame:SetPoint("TOPLEFT", parent, 10, -offsetY)
    petFrame:SetBackdrop(
      {
        bgFile = Elements.Textures.PANEL_BG_TEXTURE,
        edgeFile = Elements.Textures.EDGE_TEXTURE,
        edgeSize = 1
      }
    )
  end

  -- Pet Icon Frame
  if _G["PETPET_COMPANION_LIST_PET_ICON_FRAME_" .. frameID] then
    iconFrame = _G["PETPET_COMPANION_LIST_PET_ICON_FRAME_" .. frameID]
  else
    iconFrame = CreateFrame("Frame", "PETPET_COMPANION_LIST_PET_ICON_FRAME_" .. frameID, petFrame,
      BackdropTemplateMixin and "BackdropTemplate")
    Elements.Utilities.SetPixelScaling(iconFrame)
    iconFrame:SetBackdrop(
      {
        edgeFile = Elements.Textures.EDGE_TEXTURE,
        edgeSize = 1
      }
    )
    iconFrame:SetBackdropBorderColor(0, 0, 0)
    iconFrame:SetPoint("LEFT", petFrame, Elements.Units.Padding * 0.5, 0)
    iconFrame:SetSize(32, 32)
  end

  -- Pet Icon Texture
  if _G["PETPET_COMPANION_LIST_PET_ICON_TEXTURE" .. frameID] then
    iconTexture = _G["PETPET_COMPANION_LIST_PET_ICON_TEXTURE" .. frameID]
    iconTexture:SetTexture(petIconPath)
  else
    iconTexture = iconFrame:CreateTexture("PETPET_COMPANION_LIST_PET_ICON_TEXTURE" .. frameID, "BACKGROUND")

    iconTexture:SetTexture(petIconPath)
    iconTexture:SetPoint("CENTER", iconFrame)
    iconTexture:SetSize(32, 32)
    iconTexture:SetTexCoord(2 / 32, 30 / 32, 2 / 32, 30 / 32)
  end

  -- Pet Name Text
  if _G["PETPET_COMPANION_LIST_PET_NAME_" .. frameID] then
    petNameText = _G["PETPET_COMPANION_LIST_PET_NAME_" .. frameID]
    petNameText:SetText(petName)
  else
    petNameText = Elements.Text.CreateFreeText(PetPet.FontPath, "PETPET_COMPANION_LIST_PET_NAME_" .. frameID,
      iconFrame
      , petName, 10)

    petNameText:SetPoint("LEFT", iconFrame, 28, 0)
  end

  if PetPet.TableContains(PetPetDB["FAVOURITE_PETS"], petID) then
    ApplyFavouriteStyle(iconFrame, petFrame, petNameText)
  else
    RemoveFavouriteStyle(iconFrame, petFrame, petNameText)
  end

  petFrame:SetScript("OnClick", function()
    if PetPet.TableContains(PetPetDB["FAVOURITE_PETS"], petID) then
      -- Remove favourite pet
      table.remove(PetPetDB["FAVOURITE_PETS"], PetPet.GetItemPosition(PetPetDB["FAVOURITE_PETS"], petID))
      RemoveFavouriteStyle(iconFrame, petFrame, petNameText)
    else
      -- Add favourite pet
      table.insert(PetPetDB["FAVOURITE_PETS"], petID)
      ApplyFavouriteStyle(iconFrame, petFrame, petNameText)
    end
  end)

  petFrame:Show()
end

local function HideAllPets()
  for i = 1, PetPetDB["PAGE_SIZE"], 1 do
    if _G["PETPET_COMPANION_LIST_PET_" .. i] then
      _G["PETPET_COMPANION_LIST_PET_" .. i]:Hide()
    end
  end
end

local function DisableButton(button, buttonText)
  button:SetBackdropBorderColor(unpack(Elements.Palette.RGB.DARK_GREY))
  button:SetBackdropColor(unpack(Elements.Palette.RGB.GREY))
  buttonText:SetTextColor(unpack(Elements.Palette.RGB.LIGHT_GREY))
  buttonText:SetShadowColor(unpack(Elements.Palette.RGB.DARK_GREY))
  button:Disable()
end

local function EnableButton(button, buttonText)
  button:SetBackdropBorderColor(unpack(Elements.Palette.RGB.BLACK))
  button:SetBackdropColor(unpack(Elements.Palette.RGB.BLUE))
  buttonText:SetTextColor(unpack(Elements.Palette.RGB.WHITE))
  buttonText:SetShadowColor(unpack(Elements.Palette.RGB.BLACK))
  button:Enable()
end

local function RenderPets(parent)
  HideAllPets()
  local frameID = 1
  local pageSize = PetPetDB["PAGE_SIZE"]
  local currentPage = PetPetDB["CURRENT_PAGE"]
  local startingIndex = currentPage
  local endingIndex = pageSize
  local offsetY = Elements.Units.Padding

  if currentPage > 1 then
    startingIndex = pageSize * (currentPage - 1) + 1
    endingIndex = startingIndex + (pageSize - 1)
  end

  for i = startingIndex, endingIndex, 1 do
    local id, name, _, iconPath, _, _ = GetCompanionInfo("CRITTER", i)

    if id then
      CreatePetItem(parent, id, name, offsetY, iconPath, frameID)
      offsetY = offsetY + 43

      local nextPetId = GetCompanionInfo("CRITTER", i + 1)
      if nextPetId then
        frameID = frameID + 1
      end
    end
  end

  -- Handle enabling/disabling the Previous Page button
  if PetPetDB["CURRENT_PAGE"] == 1 then
    DisableButton(_G["PETPET_COMPANIONS_LIST_PREVIOUS_BUTTON"], _G["PETPET_COMPANIONS_LIST_PREVIOUS_BUTTON_TEXT"])
  else
    EnableButton(_G["PETPET_COMPANIONS_LIST_PREVIOUS_BUTTON"], _G["PETPET_COMPANIONS_LIST_PREVIOUS_BUTTON_TEXT"])
  end

  -- Handle enabling/disabling the Next Page button
  if (frameID < pageSize) or (GetNumCompanions("CRITTER") == (currentPage * pageSize)) then
    DisableButton(_G["PETPET_COMPANIONS_LIST_NEXT_BUTTON"], _G["PETPET_COMPANIONS_LIST_NEXT_BUTTON_TEXT"])
  else
    EnableButton(_G["PETPET_COMPANIONS_LIST_NEXT_BUTTON"], _G["PETPET_COMPANIONS_LIST_NEXT_BUTTON_TEXT"])
  end

  if (GetNumCompanions("CRITTER") < PetPetDB["PAGE_SIZE"]) then
    EnableButton(_G["PETPET_COMPANIONS_LIST_NEXT_BUTTON"], _G["PETPET_COMPANIONS_LIST_NEXT_BUTTON_TEXT"])
  end
end

local function GetPaginationStatus()
  local statusText = "Page "
  local pageCount = math.floor((GetNumCompanions("CRITTER") / PetPetDB["PAGE_SIZE"]) + 0.5)

  statusText = statusText .. PetPetDB["CURRENT_PAGE"] .. " of " .. pageCount

  return statusText
end

PetPet.CompanionList.Create = function(parent, anchorPoint)
  local pageSize = PetPetDB["PAGE_SIZE"]
  local companionsFrame =
  CreateFrame(
    "Frame",
    "PETPET_COMPANIONS_FRAME",
    parent,
    BackdropTemplateMixin and "BackdropTemplate"
  )
  Elements.Utilities.SetPixelScaling(companionsFrame)
  companionsFrame:SetSize(parent:GetWidth() - (Elements.Units.Padding * 4), parent:GetHeight())
  companionsFrame:SetPoint("TOPLEFT", anchorPoint, 0, -(Elements.Units.Padding))

  local headingText = Elements.Text.CreateText(PetPet.FontPath, "PETPET_CONFIG_FAVOURITES_HEADING", companionsFrame,
    companionsFrame, "TOPLEFT",
    Elements.Palette.Hex.RICH_YELLOW .. "Favourite Pets" .. Elements.Palette.RESET, nil, 0, -Elements.Units.Padding)

  -- Paginated List
  local listFrame = CreateFrame(
    "Frame",
    "PETPET_COMPANIONS_LIST",
    companionsFrame,
    BackdropTemplateMixin and "BackdropTemplate"
  )
  Elements.Utilities.SetPixelScaling(companionsFrame)
  local listFrameHeight = (pageSize * 42) + (Elements.Units.Padding * 2) + (pageSize)
  listFrame:SetPoint("TOPLEFT", headingText, "BOTTOMLEFT", 0, -Elements.Units.Padding)
  listFrame:SetSize(companionsFrame:GetWidth(), listFrameHeight)
  listFrame:SetBackdrop(
    {
      bgFile = Elements.Textures.PANEL_BG_TEXTURE,
      edgeFile = Elements.Textures.EDGE_TEXTURE,
      edgeSize = 1
    }
  )
  listFrame:SetBackdropBorderColor(unpack(Elements.Palette.RGB.BLACK))
  listFrame:SetBackdropColor(Elements.Palette.RGB.BLACK[1], Elements.Palette.RGB.BLACK[2], Elements.Palette.RGB.BLACK[3]
    , 0.2)

  -- Controls
  local previousPageButton = Elements.Buttons.CreateButton(listFrame, "PETPET_COMPANIONS_LIST_PREVIOUS_BUTTON",
    "< Previous Page", 120, 30
    , PetPet.FontPath
    , nil,
    nil, nil, Elements.Palette.RGB.BLACK, Elements.Palette.RGB.BLUE, "BOTTOMLEFT", nil, -(30 + Elements.Units.Padding))
  previousPageButton:SetScript("OnClick", function()
    if PetPetDB["CURRENT_PAGE"] > 1 then
      PetPetDB["CURRENT_PAGE"] = PetPetDB["CURRENT_PAGE"] - 1
    end
    RenderPets(listFrame)
    _G["PETPET_PAGINATION_TEXT"]:SetText(GetPaginationStatus())
  end)

  local paginationText = Elements.Text.CreateFreeText(PetPet.FontPath, "PETPET_PAGINATION_TEXT", listFrame,
    GetPaginationStatus(), 10)
  paginationText:SetPoint("BOTTOM", listFrame, 0, -(Elements.Units.Padding * 2.5))

  local nextPageButton = Elements.Buttons.CreateButton(listFrame, "PETPET_COMPANIONS_LIST_NEXT_BUTTON", "Next Page >",
    120, 30, PetPet.FontPath, nil,
    nil, nil, Elements.Palette.RGB.BLACK, Elements.Palette.RGB.BLUE, "BOTTOMRIGHT", nil, -(30 + Elements.Units.Padding))
  nextPageButton:SetScript("OnClick", function()
    PetPetDB["CURRENT_PAGE"] = PetPetDB["CURRENT_PAGE"] + 1
    RenderPets(listFrame)
    _G["PETPET_PAGINATION_TEXT"]:SetText(GetPaginationStatus())
  end)

  RenderPets(listFrame)

  -- Clear button
  local clearButton = Elements.Buttons.CreateButton(listFrame, "PETPET_CLEAR_COMPANION_LIST", "Clear Favourites", 120,
    30, PetPet.FontPath, nil, nil, nil, Elements.Palette.RGB.CLEAR_BUTTON_BORDER, Elements.Palette.RGB.CLEAR_BUTTON_BG,
    "TOPRIGHT", nil, Elements.Units.Padding * 3)
  clearButton:SetScript("OnClick", function()
    PetPetDB["FAVOURITE_PETS"] = {}

    for i = 1, PetPetDB["PAGE_SIZE"] do
      local petFrame = _G["PETPET_COMPANION_LIST_PET_" .. i]
      if petFrame then
        local petIcon = _G["PETPET_COMPANION_LIST_PET_ICON_FRAME_" .. i]
        local petNameText = _G["PETPET_COMPANION_LIST_PET_NAME_" .. i]
        RemoveFavouriteStyle(petIcon, petFrame, petNameText)
      end
    end
  end)
end
