local function FindAura(unit, spellID, filter)
  for i = 1, 100 do
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, auraSpellID = UnitAura(unit
      , i, filter)
    if not name then return nil end
    if spellID == auraSpellID then
      return name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge,
          nameplateShowPersonal
          , auraSpellID
    end
  end
end

local function InitialisePetPet()
  local PetPet_ActivePet = -1
  local PetPetListener = CreateFrame("Frame")

  local function CheckSummonedPets()
    local aPetIsSummoned = false;

    for i = 1, GetNumCompanions("CRITTER") do
      local _, _, _, _, isActive = GetCompanionInfo("CRITTER", i);

      if isActive then
        PetPet_ActivePet = i
        aPetIsSummoned = true;
      end
    end

    if not aPetIsSummoned then
      PetPet_ActivePet = -1
    end
  end

  CheckSummonedPets()

  PetPetListener:RegisterEvent("PLAYER_STARTED_MOVING")

  PetPetListener:SetScript("OnEvent", function(self, event, ...)
    local canSummon = not UnitAffectingCombat("player")
        and not IsMounted() and not IsFlying() and not UnitHasVehicleUI("player")
        and not (UnitIsControlling("player") and UnitChannelInfo("player")) -- If player is mind-controlling
        and not IsStealthed() and not UnitIsGhost("player")
        and not FindAura("player", 199483, "HELPFUL") -- Camouflage
        and not FindAura("player", 32612, "HELPFUL") -- Invisibility
        and not FindAura("player", 110960, "HELPFUL") -- Greater Invisibility
      	and not UnitChannelInfo("player") -- Gas Cloud
        and GetNumCompanions("CRITTER") > 0 -- Player has at least 1 pet in their Companions list
        and PetPetDB["PETPET_ACIVE"] == true -- PetPet is enabled

    if PetPet_ActivePet == -1 then
      if canSummon then
        local petID

        if #PetPetDB["FAVOURITE_PETS"] > 0 then
          local index = math.random(#PetPetDB["FAVOURITE_PETS"])
          local randomFavouritePet = PetPetDB["FAVOURITE_PETS"][index]

          for i = 1, GetNumCompanions("CRITTER") do
            local id = GetCompanionInfo("CRITTER", i);
            if randomFavouritePet == id then
              petID = i
            end
          end
        else
          petID = math.random(GetNumCompanions("CRITTER"))
        end

        CallCompanion("CRITTER", petID)
        PetPet_ActivePet = petID
      end
    else
      CheckSummonedPets()
    end
  end)
end

local loadingEvents = CreateFrame("Frame")
loadingEvents:RegisterEvent("ADDON_LOADED")
loadingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")

loadingEvents:SetScript(
  "OnEvent",
  function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "PetPet" then
      if PetPetDB == nil then
        PetPetDB = {}
      end

      if PetPetDB["PETPET_ACIVE"] == nil then
        PetPetDB["PETPET_ACIVE"] = false
      end

      if PetPetDB["FAVOURITE_PETS"] == nil then
        PetPetDB["FAVOURITE_PETS"] = {}
      end

      PetPetDB["PAGE_SIZE"] = 6
      PetPetDB["CURRENT_PAGE"] = 1

      loadingEvents:UnregisterEvent("ADDON_LOADED")
    end

    if event == "PLAYER_ENTERING_WORLD" then
      PetPet.Config.CreateConfigFrame()
      InitialisePetPet()
      loadingEvents:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
  end
)

SLASH_PETPET1 = "/petpet"

SlashCmdList["PETPET"] = function(_, _)
  InterfaceOptionsFrame_OpenToCategory("PetPet")
  InterfaceOptionsFrame_OpenToCategory("PetPet")
end
