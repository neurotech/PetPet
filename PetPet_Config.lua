local function CreateSpriteScene(parent)
  local rumiAikawa, _ = Elements.Textures.SpawnAnimatedTexture(
    "PETPET_RUMI_AIKAWA",
    parent,
    [[Interface\Addons\PetPet\Textures\configframe_rumi-aikawa]],
    1024,
    64,
    64,
    64,
    16
  )

  local pig, _ = Elements.Textures.SpawnAnimatedTexture(
    "PETPET_PIG",
    parent,
    [[Interface\Addons\PetPet\Textures\configframe_pig]],
    512,
    32,
    32,
    32,
    12
  )

  rumiAikawa:SetPoint("BOTTOMRIGHT", 0, 0)
  pig:SetPoint("BOTTOMRIGHT", -65, 14)
end

local function CreateAndAddFormElements(parent)
  local migrationText = PetPet.GetMigrationText();

  -- Addon Name & Version
  local petpetHeading, _ = Elements.Text.CreateText(PetPet.FontPath, "PETPET_CONFIG_HEADING", parent
    , parent, "TOPLEFT",
    PetPet.FrostyText("PetPet"))
  Elements.Text.CreateText(PetPet.FontPath, "PETPET_CONFIG_GENERAL_OPTIONS_HEADING", parent
  , parent, "TOPLEFT", PetPet.GetVersionText(), 9, -Elements.Units.Padding, -4, "TOPRIGHT")

  local separator = Elements.Text.CreateSeparator("PETPET_CONFIG_HEADING_SEPARATOR", parent, petpetHeading, "BOTTOMLEFT")

  -- Migration Notice
  for index, value in ipairs(migrationText) do
    local anchor
    local offsetX
    local offsetY

    if index == 1 then
      anchor = separator
      offsetX = 10
      offsetY = 0
    else
      anchor = _G["PETPET_CONFIG_MIGRATION_TEXT_" .. index - 1]
      offsetX = 0
      offsetY = 10
    end

    Elements.Text.CreateText(
      PetPet.FontPath,
      "PETPET_CONFIG_MIGRATION_TEXT_" .. index,
      parent,
      anchor,
      "BOTTOMLEFT",
      value,
      10,
      offsetX,
      offsetY
    )
  end

  -- 'Enable' checkbox
  local togglePetPetCheckbox = Elements.Checkboxes.Create("Enable PetPet", parent,
    _G["PETPET_CONFIG_MIGRATION_TEXT_" .. #migrationText], "BOTTOMLEFT", 0, PetPet.FontPath)

  -- 'Debug' checkbox
  local debugPetPetCheckbox = Elements.Checkboxes.Create("Debug Mode", parent, togglePetPetCheckbox, "BOTTOMLEFT", 0,
    PetPet.FontPath)

  return togglePetPetCheckbox, debugPetPetCheckbox
end

PetPet.Config.CreateConfigFrame = function()
  local configFrame =
      CreateFrame(
        "Frame",
        PetPet.Config.FrameName,
        InterfaceOptionsFramePanelContainer,
        BackdropTemplateMixin and "BackdropTemplate"
      )
  configFrame:SetSize(InterfaceOptionsFramePanelContainer:GetWidth(), InterfaceOptionsFramePanelContainer:GetHeight())

  configFrame.name = "PetPet"

  CreateSpriteScene(configFrame)
  local togglePetPetCheckbox, debugPetPetCheckbox = CreateAndAddFormElements(configFrame)

  InterfaceOptions_AddCategory(configFrame)

  configFrame:Hide()

  configFrame.OnCommit = function()
    PetPetDB["PETPET_ACTIVE"] = togglePetPetCheckbox:GetChecked()
    PetPetDB["PETPET_DEBUG"] = debugPetPetCheckbox:GetChecked()
  end

  configFrame.OnRefresh = function()
    togglePetPetCheckbox:SetChecked(PetPetDB["PETPET_ACTIVE"])
    debugPetPetCheckbox:SetChecked(PetPetDB["PETPET_DEBUG"])
  end

  return configFrame
end
