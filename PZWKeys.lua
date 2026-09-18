local frame = CreateFrame("Frame")

local function GetKeystoneLink()
    for bag = 0, 4 do
        local numSlots = GetContainerNumSlots(bag)
        if numSlots then
            for slot = 1, numSlots do
                local itemLink = GetContainerItemLink(bag, slot)
                if itemLink and (itemLink:find("keystone:") or itemLink:find("Keystone")) then
                    return itemLink
                end
            end
        end
    end
    return nil
end

local function SendMyKey(channel)
    local key = GetKeystoneLink()
    if key then
        SendChatMessage(key, channel)
    end
end

frame:RegisterEvent("CHAT_MSG_GUILD")
frame:RegisterEvent("CHAT_MSG_PARTY")
frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")

frame:SetScript("OnEvent", function(_, event, text)
    if not text then return end

    local clean = text:lower():match("^%s*(.-)%s*$")

    if clean == "-klucze" or clean == "-keys" then
        local channel
        if event == "CHAT_MSG_GUILD" then
            channel = "GUILD"
        elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
            channel = "PARTY"
        end

        if channel then
            SendMyKey(channel)
        end
    end
end)