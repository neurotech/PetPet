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

local function FindAura(unit, spellID, filter)
  for i = 1, 100 do
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, auraSpellID = UnitAura(unit
      , i, filter)
    if not name then return nil end
    if spellID == auraSpellID then
      return name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal
          , auraSpellID
    end
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

  if PetPet_ActivePet == -1 then
    if canSummon then
      local petID = math.random(GetNumCompanions("CRITTER"))
      CallCompanion("CRITTER", petID)
      PetPet_ActivePet = petID
    end
  else
    CheckSummonedPets()
  end
end)
