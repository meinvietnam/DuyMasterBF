-- [[ SYSTEM_OVERRIDE - AUTH: DUY_LEODUC ]]
-- [[ VERSION: V25 - OMNI REAPER (5 MINUTE EDITION) ]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
task.wait(1)

-- // CONFIGURATION
getgenv().Team = "Marines"
getgenv().HopInterval = 300 -- 5 Phút nhặt rương tối đa
_G.ChestActive = false

-- // THUẬT TOÁN TỰ ĐỘNG CHỌN PHE (CHỐNG KẸT MÀN HÌNH)
task.spawn(function()
    while true do
        if game.Players.LocalPlayer.Team == nil then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
            end)
        else
            break -- Đã vào team thành công
        end
        task.wait(2)
    end
end)

-- // THUẬT TOÁN KIỂM TRA & KÍCH HOẠT CHEST FARM (SONG SONG)
task.spawn(function()
    while true do
        if game.Players.LocalPlayer.Team ~= nil and not _G.ChestActive then
            pcall(function()
                print("[SYSTEM]: Kich hoat Chest Farm Supreme...")
                loadstring(game:HttpGet("https://raw.githubusercontent.com/trongdeptraihucscript/Main/refs/heads/main/TN-Tp-Chest.lua"))()
                _G.ChestActive = true
            end)
        end
        task.wait(10) -- Kiểm tra lại mỗi 10s, nếu script farm bị văng nó sẽ tự nạp lại
    end
end)

-- // HỆ THỐNG SERVER HOP CYBER EMERALD (MINI)
task.spawn(function()
    local TS = game:GetService("TeleportService")
    local HS = game:GetService("HttpService")
    local GS = game:GetService("GuiService")
    _G.Visited = _G.Visited or {}
    local TimeLeft = getgenv().HopInterval

    -- UI MINIMALIST (XANH LỤC BẢO)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 150, 0, 75)
    Frame.Position = UDim2.new(0.01, 0, 0.4, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(5, 20, 15)
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(0, 255, 180)
    Stroke.Thickness = 2

    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.TextColor3 = Color3.fromRGB(0, 255, 150)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 10
    Text.Text = "DUY LEODUC V25\nStarting..."

    local function ServerHop()
        Text.Text = "SYSTEM: HOPPING..."
        local success, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100")
        end)
        if success then
            local servers = HS:JSONDecode(result)
            for _, s in pairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId and not _G.Visited[s.id] then
                    _G.Visited[s.id] = true
                    TS:TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                    return
                end
            end
        end
    end

    -- AUTO RECONNECT (VSPHONE PROTECTION)
    GS.ErrorMessageChanged:Connect(function()
        task.wait(1)
        ServerHop()
    end)

    -- VÒNG LẶP ĐẾM NGƯỢC & KIỂM TRA TRẠNG THÁI
    while task.wait(1) do
        TimeLeft = TimeLeft - 1
        local teamText = game.Players.LocalPlayer.Team and "Marines" or "Waiting..."
        local farmText = _G.ChestActive and "Active" or "Loading..."
        
        Text.Text = "DUY LEODUC - V25\nTeam: "..teamText.."\nFarm: "..farmText.."\nHop in: "..TimeLeft.."s"
        
        -- Anti-AFK & Keep Alive
        if TimeLeft % 15 == 0 then
            pcall(function() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
        end
        
        if TimeLeft <= 0 then
            ServerHop()
            TimeLeft = getgenv().HopInterval
        end
    end
end)
