PetPet = {}

PetPet.FontPath = "Interface\\Addons\\PetPet\\Elements\\Fonts\\elements.ttf"

PetPet.Config = {}
PetPet.Config.FrameName = "PetPetConfigFrame"

PetPet.FrostyText = function(text)
  local frostyText = ""
  local paletteIndex = 1
  local palette = {
    "719BFF",
    "80A5FF",
    "8EAFFF",
    "9DBAFF",
    "ABC4FF",
    "BACEFF",
    "C8D8FF",
    "D7E3FF",
    "E5EDFF",
    "F4F7FF"
  }

  for char in text:gmatch(".") do
    frostyText = frostyText .. "|cff" .. palette[paletteIndex] .. char .. "|r"
    paletteIndex = paletteIndex + 1
  end

  return frostyText
end

PetPet.GetVersionText = function()
  return Elements.Palette.Hex.LIGHT_GREY .. GetAddOnMetadata("PetPet", "Version") .. Elements.Palette.RESET
end

PetPet.GetMigrationText = function()
  local icon = "|TInterface\\Icons\\spell_arcane_focusedpower:32|t ";
  local heading = icon .. "Please note!";

  local text = {}
  table.insert(text,
    "As of version 3.0.0, PetPet now uses the in-game Pet Journal to source it's list of favourite pets.")
  table.insert(text,
    "Please ensure you have your favourite pets set in the Pet Journal UI for PetPet to function correctly.")

  return heading, text
end
