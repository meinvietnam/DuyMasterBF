-- [[ AUTH: DUY_LEODUC | VERSION: V22_SUPREME ]]
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 1. THIẾT LẬP AUTO CHỌN PHE MARINES (CỰC MẠNH)
getgenv().Team = "Marines"
local function ForceJoin()
    pcall(function()
        local player = game.Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        -- Thử chọn phe liên tục cho đến khi thành công
        if player.Team == nil then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
        end
    end)
end

-- Chạy chọn phe
ForceJoin()

-- 2. KÍCH HOẠT SCRIPT NHẶT RƯƠNG (CHẠY SONG SONG)
task.spawn(function()
    task.wait(3) -- Đợi 3 giây sau khi chọn phe để script farm không bị lỗi
    print("Master Duy: Loading Chest Script...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/trongdeptraihucscript/Main/refs/heads/main/TN-Tp-Chest.lua"))()
    end)
end)

-- 3. HỆ THỐNG SERVER HOP MINI XANH (LE*DU*DUY_00*)
task.spawn(function()
    local TS = game:GetService("TeleportService")
    local HS = game:GetService("HttpService")
    local GS = game:GetService("GuiService")
    _G.Visited = _G.Visited or {}
    local Time = 120

    -- Tạo Menu Xanh (Như ảnh Master gửi)
    local G = Instance.new("ScreenGui", game.CoreGui)
    local F = Instance.new("Frame", G)
    F.Size, F.Position = UDim2.new(0,150,0,70), UDim2.new(0.01,0,0.4,0)
    F.BackgroundColor3 = Color3.fromRGB(0, 15, 10)
    F.BorderSizePixel = 0
    F.Active, F.Draggable = true, true
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", F).Color = Color3.fromRGB(0, 255, 150)

    local L = Instance.new("TextLabel", F)
    L.Size, L.BackgroundTransparency = UDim2.new(1,0,1,0), 1
    L.TextColor3, L.Font, L.TextSize = Color3.fromRGB(0, 255, 127), "GothamBold", 10
    
    local function Hop()
        local s_list = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
        for _, v in pairs(s_list.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId and not _G.Visited[v.id] then
                _G.Visited[v.id] = true
                TS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                break
            end
        end
    end

    GS.ErrorMessageChanged:Connect(function() task.wait(0.5) Hop() end)

    while task.wait(1) do
        Time = Time - 1
        L.Text = "MASTER DUY - V22\nTeam: Marines (Auto)\nHop: "..Time.."s\nby le*du*duy_00*"
        if Time % 20 == 0 then pcall(function() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end
        if Time <= 0 then Hop() Time = 120 end
    end
end)
