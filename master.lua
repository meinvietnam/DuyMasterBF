-- [[ AUTH: DUY_LEODUC | VERSION: V21_FINAL_COMBINE ]]
-- [[ OPTIMIZED FOR VSPHONE & BLOX FRUIT ]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
task.wait(1)

-- 1. AUTO JOIN TEAM MARINES
getgenv().Team = "Marines"
pcall(function()
    if game:GetService("Players").LocalPlayer.Team == nil then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
    end
end)

-- 2. CHẠY SONG SONG: CHEST FARM + SERVER HOP
task.spawn(function()
    -- Luồng chạy Script Chest của Master
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/trongdeptraihucscript/Main/refs/heads/main/TN-Tp-Chest.lua"))()
    end)
end)

task.spawn(function()
    -- Luồng chạy Server Hop Menu Xanh Mini
    local TS = game:GetService("TeleportService")
    local HS = game:GetService("HttpService")
    local GS = game:GetService("GuiService")
    
    _G.Visited = _G.Visited or {}
    local Time = 120
    
    -- Giao diện Emerald Mini (Nhỏ gọn cho VsPhone)
    local G = Instance.new("ScreenGui", game.CoreGui)
    local F = Instance.new("Frame", G)
    F.Size = UDim2.new(0, 140, 0, 65)
    F.Position = UDim2.new(0.01, 0, 0.35, 0)
    F.BackgroundColor3 = Color3.fromRGB(0, 20, 15)
    F.Active = true
    F.Draggable = true
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    local S = Instance.new("UIStroke", F)
    S.Color = Color3.fromRGB(0, 255, 127)
    S.Thickness = 1.5

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0)
    L.BackgroundTransparency = 1
    L.TextColor3 = Color3.fromRGB(0, 255, 150)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 10
    L.Text = "MASTER DUY - V21\nLoading..."

    local function Hop()
        L.Text = "Finding Sea..."
        local success, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100")
        end)
        if success then
            local servers = HS:JSONDecode(result)
            for _, v in pairs(servers.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId and not _G.Visited[v.id] then
                    _G.Visited[v.id] = true
                    TS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                    return
                end
            end
        end
    end

    -- Auto Re-connect khi văng
    GS.ErrorMessageChanged:Connect(function() task.wait(0.5) Hop() end)

    -- Vòng lặp đếm ngược
    while task.wait(1) do
        Time = Time - 1
        L.Text = "MASTER DUY - V21\nHop: "..Time.."s\nby le*du*duy_00*"
        if Time % 20 == 0 then pcall(function() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end
        if Time <= 0 then Hop() Time = 120 end
    end
end)
