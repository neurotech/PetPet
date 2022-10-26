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
  local petpetHeading, petpetHeadingText = Elements.Text.CreateText(PetPet.FontPath, "PETPET_CONFIG_HEADING", parent
    , parent, "TOPLEFT",
    PetPet.FrostyText("PetPet"))
  local versionText = Elements.Text.CreateText(PetPet.FontPath, "PETPET_CONFIG_GENERAL_OPTIONS_HEADING", parent
    , parent, "TOPLEFT", PetPet.GetVersionText(), 9, -Elements.Units.Padding, -4, "TOPRIGHT")

  local separator = Elements.Text.CreateSeparator("PETPET_CONFIG_HEADING_SEPARATOR", parent, petpetHeading, "BOTTOMLEFT")
  local generalOptionsHeading = Elements.Text.CreateText(PetPet.FontPath, "PETPET_CONFIG_GENERAL_OPTIONS_HEADING", parent
    , separator, "BOTTOMLEFT", Elements.Palette.Hex.RICH_YELLOW .. "General Options" .. Elements.Palette.RESET, 12)

  local togglePetPetCheckbox = Elements.Checkboxes.Create("Enable PetPet", parent, generalOptionsHeading, "BOTTOMLEFT")

  return togglePetPetCheckbox
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
  local togglePetPetCheckbox = CreateAndAddFormElements(configFrame)

  PetPet.CompanionList.Create(configFrame, togglePetPetCheckbox)

  InterfaceOptions_AddCategory(configFrame)

  configFrame:Hide()

  function configFrame.refresh()
    togglePetPetCheckbox:SetChecked(PetPetDB["PETPET_ACIVE"])
  end

  function configFrame.okay()
    PetPetDB["PETPET_ACIVE"] = togglePetPetCheckbox:GetChecked()
  end

  return configFrame
end
