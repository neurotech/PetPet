PetPet = {}

PetPet.FontPath = "Interface\\Addons\\PetPet\\Elements\\Fonts\\elements.ttf"
PetPet.FavouriteIconPath = "Interface\\Addons\\PetPet\\Textures\\favourite-icon"

PetPet.CompanionList = {}

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

PetPet.TableContains = function(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end

  return false
end

PetPet.GetItemPosition = function(table, item)
  local position = -1

  for index, value in pairs(table) do
    if value == item then
      position = index
    end
  end

  return position
end
