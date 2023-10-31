local function FindAura(unit, spellID, filter)
  for i = 1, 100 do
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, auraSpellID =
        UnitAura(unit
        , i, filter)
    if not name then return nil end
    if spellID == auraSpellID then
      return name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge,
          nameplateShowPersonal
          , auraSpellID
    end
  end
end

local function HasActivePet(numPets)
  local activePet = false

  for i = 1, numPets do
    local _, _, _, _, isActive = GetCompanionInfo("CRITTER", i);
    if isActive then
      activePet = true
    end
  end

  return activePet;
end

local function InitialisePetPet()
  local PetPetListener = CreateFrame("Frame")

  PetPetListener:RegisterEvent("PLAYER_STARTED_MOVING")

  PetPetListener:SetScript("OnEvent", function()
    local favouritePets = {}
    local numPets, numOwned = C_PetJournal.GetNumPets()
    local canSummon = not UnitAffectingCombat("player")
        and not IsMounted() and not IsFlying() and not UnitHasVehicleUI("player")
        -- If player is mind-controlling:
        and not (UnitIsControlling("player") and UnitChannelInfo("player"))
        and not IsStealthed() and not UnitIsGhost("player")
        -- Camouflage:
        and not FindAura("player", 199483, "HELPFUL")
        -- Invisibility:
        and not FindAura("player", 32612, "HELPFUL")
        -- Greater Invisibility:
        and not FindAura("player", 110960, "HELPFUL")
        -- Gas Cloud:
        and not UnitChannelInfo("player")
        and not HasActivePet(numPets)
        -- Player has at least 1 pet in their Companions list:
        and numOwned > 0
        -- PetPet is enabled:
        and PetPetDB["PETPET_ACTIVE"] == true

    if canSummon then
      for i = 1, numPets do
        local petID, _, owned, _, _, favorite, _, _ = C_PetJournal.GetPetInfoByIndex(i);

        if owned and favorite then
          table.insert(favouritePets, tostring(petID))
        end
      end

      if PetPetDB["PETPET_DEBUG"] == true then
        print("favouritePets (" .. #favouritePets .. "):")

        for index, value in ipairs(favouritePets) do
          local _, _, _, _, _, _, _, name, _, _, _, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByPetID(value)
          print(index .. ": " .. name .. " (" .. value .. ")")
        end
      end

      if #favouritePets > 0 then
        C_PetJournal.SummonPetByGUID(favouritePets[math.random(#favouritePets)])
      end
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

      if PetPetDB["PETPET_ACTIVE"] == nil then
        if PetPetDB["PETPET_ACIVE"] then
          PetPetDB["PETPET_ACTIVE"] = PetPetDB["PETPET_ACIVE"]
        else
          PetPetDB["PETPET_ACTIVE"] = false
        end
      end

      -- Fix spelling mistake
      if PetPetDB["PETPET_ACIVE"] then
        PetPetDB["PETPET_ACIVE"] = nil
      end

      if PetPetDB["PETPET_ACTIVE"] == nil then
        PetPetDB["PETPET_ACTIVE"] = false
      end

      if PetPetDB["PETPET_DEBUG"] == nil then
        PetPetDB["PETPET_DEBUG"] = false
      end

      -- Clean up old config settings:
      if PetPetDB["FAVOURITE_PETS"] then
        PetPetDB["FAVOURITE_PETS"] = nil
      end

      if PetPetDB["PAGE_SIZE"] then
        PetPetDB["PAGE_SIZE"] = nil
      end

      if PetPetDB["CURRENT_PAGE"] then
        PetPetDB["CURRENT_PAGE"] = nil
      end

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
