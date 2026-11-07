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

local function MountedFlyingOrVehicle()
    local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
    local isMoPClassic = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC
    local isFlyingOrVehicle = IsFlying("player") or UnitHasVehicleUI("player")

    if isMoPClassic or isRetail then
        return isFlyingOrVehicle
    end

    return IsMounted() or isFlyingOrVehicle
end

local function InitialisePetPet()
    local PetPetListener = CreateFrame("Frame")
    PetPetListener:RegisterEvent("PLAYER_STARTED_MOVING")

    PetPetListener:SetScript("OnEvent", function()
        -- Addon switched off with /petpet off:
        if not PetPetDB.enabled then return end
            
        local favouritePets = {}
        local numPets, numOwned = C_PetJournal.GetNumPets()
        local petActive = HasActivePet(numPets) or C_PetJournal.GetSummonedPetGUID() ~= nil
        local hasSecretAuras = C_Secrets.ShouldAurasBeSecret()

        -- Player is not:
        -- In combat:
        local canSummon = not UnitAffectingCombat("player")
            -- Mounted / Flying / In a vehicle:
            and not MountedFlyingOrVehicle()
            -- Mind-controlling:
            and not (UnitIsControlling("player") and UnitChannelInfo("player"))
            -- Stealthed / Dead
            and not IsStealthed() and not UnitIsGhost("player")
            -- Has no secret auras:
            and not hasSecretAuras
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

local function DismissActivePet()
    local guid = C_PetJournal.GetSummonedPetGUID and C_PetJournal.GetSummonedPetGUID()

    if guid then
        -- Summoning the pet that is already out dismisses it:
        C_PetJournal.SummonPetByGUID(guid)
    elseif DismissCompanion then
        DismissCompanion("CRITTER")
    end
end

local function PetPetPrint(msg)
    print("|cff33ff99PetPet:|r " .. msg)
end

SLASH_PETPET1 = "/petpet"
SlashCmdList["PETPET"] = function(input)
    local cmd = strlower(strtrim(input or ""))

    if type(PetPetDB) ~= "table" then
        PetPetDB = {}
    end

    if cmd == "on" then
        PetPetDB.enabled = true
        PetPetPrint("|cff00ff00on|r - a random pet will be summoned when you start moving.")
    elseif cmd == "off" then
        PetPetDB.enabled = false
        DismissActivePet()
        PetPetPrint("|cffff0000off|r - pets will no longer be summoned automatically.")
    else
        local state = (PetPetDB.enabled ~= false) and "|cff00ff00on|r" or "|cffff0000off|r"
        PetPetPrint("currently " .. state .. ". Use /petpet on or /petpet off.")
    end
end

local loadingEvents = CreateFrame("Frame")
loadingEvents:RegisterEvent("ADDON_LOADED")
loadingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")

loadingEvents:SetScript(
    "OnEvent",
    function(_, event, arg1)
        if event == "ADDON_LOADED" and arg1 == "PetPet" then
            -- Initialise saved settings (enabled by default):
            if type(PetPetDB) ~= "table" then
                PetPetDB = {}
            end

            if PetPetDB.enabled == nil then
                PetPetDB.enabled = true
            end


            loadingEvents:UnregisterEvent("ADDON_LOADED")
        end

        if event == "PLAYER_ENTERING_WORLD" then
            InitialisePetPet()
            loadingEvents:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end
)
