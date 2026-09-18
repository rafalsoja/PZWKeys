local autoInsertFrame = CreateFrame("Frame")

-- List conflicting addons
local conflictingAddons = {
    "AngryKeystones",
    "GottaGoFast",
    "AstralKeys",
    "KeystoneManager",
    "Keypad",
}

local function IsConflictingAddonLoaded()
    for _, name in ipairs(conflictingAddons) do
        if IsAddOnLoaded(name) then
            return name
        end
    end
    return nil
end

local function FindKeystone()
    for bag = 0, 4 do
        local slots = GetContainerNumSlots(bag)
        if slots and slots > 0 then
            for slot = 1, slots do
                local link = GetContainerItemLink(bag, slot)
                if link and (link:find("keystone:") or link:find("Keystone")) then
                    return bag, slot
                end
            end
        end
    end
    return nil, nil
end

local function AutoInsertKeystone()
    -- Don't insert if another auto-insert addon is already running
    if IsConflictingAddonLoaded() then return end

    local bag, slot = FindKeystone()
    if not bag then return end

    ClearCursor()
    PickupContainerItem(bag, slot)

    if CursorHasItem() then
        if C_ChallengeMode and C_ChallengeMode.SlotKeystone then
            C_ChallengeMode.SlotKeystone()
        elseif ChallengesKeystoneFrameReceptacle then
            ChallengesKeystoneFrameReceptacle:Click()
        end
        ClearCursor()
    end
end

local hooked = false
local function HookKeystoneFrame()
    if hooked or not ChallengesKeystoneFrame then return end

    ChallengesKeystoneFrame:HookScript("OnShow", AutoInsertKeystone)
    hooked = true
end

-- Events
autoInsertFrame:RegisterEvent("ADDON_LOADED")
autoInsertFrame:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")

autoInsertFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN" then
        AutoInsertKeystone()
    elseif event == "ADDON_LOADED" and arg1 == "Blizzard_ChallengesUI" then
        HookKeystoneFrame()
    end
end)