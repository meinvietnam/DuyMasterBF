-- [[ AUTH: DUY_LEODUC | VERSION: V23_GOD_MODE ]]
-- [[ AUTO TEAM + AUTO CHEST + AUTO HOP + AUTO RECONNECT ]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 1. BIẾN TOÀN CỤC CHỐNG LẶP
getgenv().Team = "Marines"
_G.ChestScriptLoaded = false

-- 2. HÀM TỰ ĐỘNG CHỌN PHE (CHẠY LIÊN TỤC CHO ĐẾN KHI XONG)
task.spawn(function()
    while not game.Players.LocalPlayer.Team do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
        end)
        task.wait(1)
    end
end)

-- 3. HÀM CHẠY SCRIPT CHEST SONG SONG (THỬ LẠI NẾU THẤT BẠI)
task.spawn(function()
    while not _G.ChestScriptLoaded do
        if game.Players.LocalPlayer.Team then
            pcall(function()
                print("Master Duy: Kich hoat Chest Farm...")
                loadstring(game:HttpGet("https://raw.githubusercontent.com/trongdeptraihucscript/Main/refs/heads/main/TN-Tp-Chest.lua"))()
                _G.ChestScriptLoaded = true
            end)
        end
        task.wait(5) -- Nếu chưa load được thì 5s sau thử lại
    end
end)

-- 4. HỆ THỐNG SERVER HOP & AUTO REJOIN (MENU XANH)
task.spawn(function()
    local TS = game:GetService("TeleportService")
    local HS = game:GetService("HttpService")
    local GS = game:GetService("GuiService")
    _G.Visited = _G.Visited or {}
    local Time = 120

    -- Giao dien Emerald Mini
    local G = Instance.new("ScreenGui", game.CoreGui)
    local F = Instance.new("Frame", G)
    F.Size, F.Position = UDim2.new(0,160,0,80), UDim2.new(0.01,0,0.4,0)
    F.BackgroundColor3 = Color3.fromRGB(0, 15, 10)
    F.Active, F.Draggable = true, true
    Instance.new("UIStroke", F).Color = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", F)

    local L = Instance.new("TextLabel", F)
    L.Size, L.BackgroundTransparency = UDim2.new(1,0,1,0), 1
    L.TextColor3, L.Font, L.TextSize = Color3.fromRGB(0, 255, 127), "GothamBold", 10
    
    local function Hop()
        local s_list = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
        for _, v in pairs(s_list.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId and not _G.Visited[v.id] then
                _G.Visited[v.id] = true
                TS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                return
            end
        end
    end

    -- [QUAN TRỌNG] TỰ ĐỘNG VÀO LẠI KHI VĂNG (AUTO RECONNECT)
    GS.ErrorMessageChanged:Connect(function()
        task.wait(0.5)
        Hop()
    end)

    while task.wait(1) do
        Time = Time - 1
        local teamStatus = game.Players.LocalPlayer.Team and "Joined" or "Joining..."
        local chestStatus = _G.ChestScriptLoaded and "Running" or "Loading..."
        
        L.Text = "MASTER DUY - V23\nTeam: "..teamStatus.."\nChest: "..chestStatus.."\nHop: "..Time.."s\nby le*du*duy_00*"
        
        -- Anti-AFK
        if Time % 20 == 0 then pcall(function() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end
        
        if Time <= 0 then Hop() Time = 120 end
    end
end)
