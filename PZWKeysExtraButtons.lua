local function CreateExtraButtons()
    if not ChallengesKeystoneFrame then return end
    if ChallengesKeystoneFrame.PZWReadyButton then return end

    local startButton = ChallengesKeystoneFrame.StartButton
    if not startButton then return end

    -- Ready Check button (left)
    local readyBtn = CreateFrame("Button", nil, ChallengesKeystoneFrame, "UIPanelButtonTemplate")
    readyBtn:SetSize(90, 22)
    readyBtn:SetText("Ready Check")
    readyBtn:SetPoint("RIGHT", startButton, "LEFT", -8, 0)
    readyBtn:SetScript("OnClick", function()
        if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
            DoReadyCheck()
        else
            print("|cff00aeefPZW|r|cffffd100Keys:|r Only leader/assistant can start a ready check.")
        end
    end)
    ChallengesKeystoneFrame.PZWReadyButton = readyBtn

    -- Pull button (right)
    local pullBtn = CreateFrame("Button", nil, ChallengesKeystoneFrame, "UIPanelButtonTemplate")
    pullBtn:SetSize(70, 22)
    pullBtn:SetText("Pull 10")
    pullBtn:SetPoint("LEFT", startButton, "RIGHT", 8, 0)
    pullBtn:SetScript("OnClick", function()
        -- Check group permissions first
        local isLeaderOrAssist = UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
        if not isLeaderOrAssist and IsInGroup() then
            print("|cff00aeefPZW|r|cffffd100Keys:|r Only group leader or assistant can start a pull timer.")
            return
        end

        -- BigWigs
        if SlashCmdList["BIGWIGSPULL"] then
            SlashCmdList["BIGWIGSPULL"]("10")
            return
        end

        -- DBM
        if SlashCmdList["DEADLYBOSSMODS"] then
            SlashCmdList["DEADLYBOSSMODS"]("pull 10")
            return
        end
    end)
    ChallengesKeystoneFrame.PZWPullButton = pullBtn
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, addon)
    if addon == "Blizzard_ChallengesUI" then
        if ChallengesKeystoneFrame then
            ChallengesKeystoneFrame:HookScript("OnShow", CreateExtraButtons)
            CreateExtraButtons()
        end
    end
end)

if ChallengesKeystoneFrame then
    ChallengesKeystoneFrame:HookScript("OnShow", CreateExtraButtons)
    CreateExtraButtons()
end