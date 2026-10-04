local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local Cam = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")

if CG:FindFirstChild("TerrorSakenHub") then CG["TerrorSakenHub"]:Destroy() end

_G.Aim = false; _G.Alvo = "Head"; _G.FOV = 130; _G.Box = false; _G.Linha = false
_G.Speed = false; _G.Noclip = false; _G.Fly = false; _G.Fling = false; _G.Spawn = nil
local AlvoFixo = nil -- Guarda o jogador travado até a morte

local UI = Instance.new("ScreenGui", CG); UI.Name = "TerrorSakenHub"; UI.ResetOnSpawn = false
local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 360, 0, 260); Main.Position = UDim2.new(0.5, -180, 0.5, -130); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.BorderSizePixel = 1; Main.BorderColor3 = Color3.fromRGB(255, 0, 0); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Title.Text = "★ TERRORSAKEN HUB (MORTAL LOCK) ★"; Title.TextColor3 = Color3.fromRGB(255, 0, 0); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 6)

local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -16, 1, -40); Scroll.Position = UDim2.new(0, 8, 0, 35); Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0, 0, 0, 650); Scroll.ScrollBarThickness = 4
local List = Instance.new("UIListLayout", Scroll); List.Padding = UDim.new(0, 4)

local FOVF = Instance.new("Frame", UI); FOVF.Size = UDim2.new(0, _G.FOV*2, 0, _G.FOV*2); FOVF.BackgroundTransparency = 1
local FSt = Instance.new("UIStroke", FOVF); FSt.Color = Color3.fromRGB(255, 0, 0); FSt.Thickness = 1
Instance.new("UICorner", FOVF).CornerRadius = UDim.new(1, 0)

RS.RenderStepped:Connect(function()
    local M = UIS:GetMouseLocation()
    FOVF.Position = UDim2.new(0, M.X - _G.FOV, 0, M.Y - _G.FOV - 36)
end)

local Toggle = Instance.new("ImageButton", UI); Toggle.Size = UDim2.new(0, 60, 0, 60); Toggle.Position = UDim2.new(0, 15, 0, 120); Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Toggle.BorderSizePixel = 1; Toggle.BorderColor3 = Color3.fromRGB(255, 0, 0); Toggle.Image = "http://roblox.com"; Toggle.Active = true; Toggle.Draggable = true
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

local ToggleText = Instance.new("TextLabel", Toggle); ToggleText.Size = UDim2.new(1, 0, 1, 0); ToggleText.BackgroundTransparency = 1; ToggleText.Text = "MENU"; ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleText.Font = Enum.Font.GothamBold; ToggleText.TextSize = 12
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function AddToggle(txt, val, cb)
    local B = Instance.new("TextButton", Scroll); B.Size = UDim2.new(1, 0, 0, 30); B.BackgroundColor3 = Color3.fromRGB(25, 25, 25); B.TextColor3 = Color3.fromRGB(255, 255, 255); B.Text = txt .. " : OFF"; B.Font = Enum.Font.Gotham; B.TextSize = 12; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
    B.MouseButton1Click:Connect(function()
        _G[val] = not _G[val]; B.BackgroundColor3 = _G[val] and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(25, 25, 25); B.Text = txt .. (_G[val] and " : ON" or " : OFF"); cb(_G[val])
    end)
end

local function AddBtn(txt, cb)
    local B = Instance.new("TextButton", Scroll); B.Size = UDim2.new(1, 0, 0, 30); B.BackgroundColor3 = Color3.fromRGB(35, 35, 35); B.TextColor3 = Color3.fromRGB(255, 255, 255); B.Text = txt; B.Font = Enum.Font.Gotham; B.TextSize = 12; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
    B.MouseButton1Click:Connect(cb)
end

AddToggle("Ativar Aimbot", "Aim", function(v) if not v then AlvoFixo = nil end end)
AddBtn("-> Mirar na Cabeça", function() _G.Alvo = "Head"; AlvoFixo = nil end)
AddBtn("-> Mirar no Peito", function() _G.Alvo = "HumanoidRootPart"; AlvoFixo = nil end)
AddBtn("-> Mirar no Pé", function() _G.Alvo = "LeftFoot"; AlvoFixo = nil end)
AddBtn("-> Mirar na Cabeça de Baixo", function() _G.Alvo = "LowerTorso"; AlvoFixo = nil end)

-- Sistema de Trava Hardcore: Gruda no jogador até ele morrer
RS.RenderStepped:Connect(function()
    if _G.Aim then
        local M = UIS:GetMouseLocation()
        
        -- Se já existe um alvo fixado, checa estritamente se ele está vivo no servidor
        if AlvoFixo and AlvoFixo.Character and AlvoFixo.Character:FindFirstChild(_G.Alvo) then
            local Hum = AlvoFixo.Character:FindFirstChildOfClass("Humanoid")
            if Hum and Hum.Health > 0 then
                -- Força a câmera a olhar diretamente para a parte do corpo do alvo sem soltar por nada
                Cam.CFrame = CFrame.new(Cam.CFrame.Position, AlvoFixo.Character[_G.Alvo].Position)
                return -- Corta o código aqui para não buscar outras pessoas
            else
                AlvoFixo = nil -- Se a vida for menor ou igual a zero, limpa a trava
            end
        end

        -- Busca um novo alvo dentro do FOV somente se não houver ninguém fixado
        local MelhorJogador, MD = nil, _G.FOV
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild(_G.Alvo) then
                local H = p.Character:FindFirstChildOfClass("Humanoid")
                if H and H.Health > 0 then
                    local PT, NaTela = Cam:WorldToViewportPoint(p.Character[_G.Alvo].Position)
                    if NaTela then 
                        local D = (Vector2.new(PT.X, PT.Y) - M).Magnitude
                        if D < MD then MD = D; MelhorJogador = p end 
                    end
                end
            end
        end
        
        if MelhorJogador then 
            AlvoFixo = MelhorJogador -- Fixa o jogador na variável global
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, AlvoFixo.Character[_G.Alvo].Position) 
        end
    end
end)

AddToggle("Esp Box Silhueta", "Box", function() end)
AddToggle("Esp Linha Nome", "Linha", function() end)

RS.RenderStepped:Connect(function()
    for _, p in pairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character then
            local Hl = p.Character:FindFirstChildOfClass("Highlight")
            if _G.Box then
                if not Hl then 
                    Hl = Instance.new("Highlight", p.Character)
                    Hl.FillColor = Color3.fromRGB(255,0,0)
                    Hl.OutlineColor = Color3.fromRGB(255,255,255)
                    Hl.FillTransparency = 0.5 
                end
            else if Hl then Hl:Destroy() end end
            
            local Bg = p.Character:FindFirstChild("EspLGui")
            if _G.Linha then
                if not Bg and p.Character:FindFirstChild("Head") then
                    Bg = Instance.new("BillboardGui", p.Character); Bg.Name = "EspLGui"; Bg.Size = UDim2.new(0,100,0,25); Bg.AlwaysOnTop = true; Bg.StudsOffset = Vector3.new(0,3,0)
                    local T = Instance.new("TextLabel", Bg); T.Size = UDim2.new(1,0,1,0); T.BackgroundTransparency = 1; T.TextColor3 = Color3.fromRGB(255,0,0); T.Text = p.Name; T.Font = Enum.Font.SourceSansBold; T.TextSize = 13
                end
            else if Bg then Bg:Destroy() end end
        end
    end
end)

AddToggle("Speed Hack", "Speed", function() end)
RS.Heartbeat:Connect(function() if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.Speed and 45 or 16 end end)

AddToggle("Noclip Parede", "Noclip", function() end)
RS.Stepped:Connect(function() if _G.Noclip and LP.Character then for _, o in pairs(LP.Character:GetChildren()) do if o:IsA("BasePart") then o.CanCollide = false end end end end)

local BV = Instance.new("BodyVelocity")
AddToggle("Fly Voo", "Fly", function(v)
    if v and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        BV.Parent = LP.Character.HumanoidRootPart; BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        spawn(function() while _G.Fly do BV.Velocity = Cam.CFrame.LookVector * 50; task.wait() end end)
    else BV.Parent = nil end
end)

AddToggle("Fling Girar", "Fling", function() end)
RS.Heartbeat:Connect(function() if _G.Fling and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 99999, 0) end end)

AddBtn("Salvar Spawn Point", function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then _G.Spawn = LP.Character.HumanoidRootPart.CFrame end end)
AddBtn("Tp para Spawn Salvo", function() if _G.Spawn and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = _G.Spawn end end)

local function MovePlrs(dist)
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, dist) end
        end
    end
end
AddBtn("Tp All Visual", function() MovePlrs(-4) end)
AddBtn("Bring Visual", function() MovePlrs(-2) end)
AddBtn("Btools Visual", function() local H = Instance.new("HopperBin", LP.Backpack); H.BinType = Enum.BinType.Hammer end)
