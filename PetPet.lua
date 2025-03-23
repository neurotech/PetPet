local function FindAura(unit, spellID, filter)
  for i = 1, 100 do
    local aura = C_UnitAuras.GetAuraDataByIndex(unit, i, filter)

    if aura == nil then return nil end

    if spellID == aura.spellId then
      return aura
    end
  end
end

local function HasActivePet(numPets)
  if C_PetJournal.IsCurrentlySummoned == nil then
    return false
  end

  local activePet = false
  local ownedPets = {}

  for i = 1, numPets do
    local petID, _, owned, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)

    if owned then
      table.insert(ownedPets, petID)
    end
  end

  for i = 1, #ownedPets do
    local petID = ownedPets[i]
    local isSummoned = C_PetJournal.IsCurrentlySummoned(petID)

    if isSummoned then
      activePet = true
    end
  end

  return activePet
end

local function InitialisePetPet()
  local PetPetListener = CreateFrame("Frame")
  PetPetListener:RegisterEvent("PLAYER_STARTED_MOVING")

  PetPetListener:SetScript("OnEvent", function()
    local favouritePets = {}
    local numPets, numOwned = C_PetJournal.GetNumPets()
    local petActive = HasActivePet(numPets) or C_PetJournal.GetSummonedPetGUID() ~= nil

    -- DEBUG
    print("C_PetJournal.GetSummonedPetGUID(): " .. (C_PetJournal.GetSummonedPetGUID() or "nil"))
    print("HasActivePet(numPets): " .. tostring(HasActivePet(numPets)))
    -- DEBUG

    local canSummon = not UnitAffectingCombat("player")
        -- Mounted / Flying / In a vehicle:
        and not IsMounted() and not IsFlying() and not UnitHasVehicleUI("player")
        -- If player is mind-controlling:
        and not (UnitIsControlling("player") and UnitChannelInfo("player"))
        -- Stealthed / Dead
        and not IsStealthed() and not UnitIsGhost("player")
        -- Camouflage:
        and not FindAura("player", 199483, "HELPFUL")
        -- Invisibility:
        and not FindAura("player", 32612, "HELPFUL")
        -- Greater Invisibility:
        and not FindAura("player", 110960, "HELPFUL")
        -- Gas Cloud:
        and not UnitChannelInfo("player")
        -- Does not have a pet summoned:
        and not petActive
        -- Has at least 1 pet in their Companions list:
        and numOwned > 0

    if canSummon then
      for i = 1, numPets do
        local petID, _, owned, _, _, favorite, _, _ = C_PetJournal.GetPetInfoByIndex(i)

        if owned and favorite then
          table.insert(favouritePets, tostring(petID))
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
      -- Clean up old config settings:
      if PetPetDB ~= nil then
        PetPetDB = {}
      end

      loadingEvents:UnregisterEvent("ADDON_LOADED")
    end

    if event == "PLAYER_ENTERING_WORLD" then
      InitialisePetPet()
      loadingEvents:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
  end
)
