local function API_Check()
    local success, result = pcall(function()
        return Drawing ~= nil
    end)
    return success and result
end

local Find_Required = API_Check()

if not Find_Required then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Aetherial Hub";
        Text = "Script could not load because Drawing API is not available.";
        Duration = math.huge;
        Button1 = "OK"
    })

    return
end

local Find_Required = API_Check()

if Find_Required == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Aetherial Hub";
        Text = "Script could not load because of your executor.";
        Duration = math.huge;
        Button1 = "OK"
    })

    return
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TestService = game:GetService("TestService")

local Typing = false
local TracersEnabled = true  -- Variable to manage the toggle state

_G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
_G.DefaultSettings = false   -- If set to true then the tracer script would run with default settings regardless of any changes you made.

_G.TeamCheck = false   -- If set to true then the script would create tracers only for the enemy team members.

--[!]-- ONLY ONE OF THESE VALUES SHOULD BE SET TO TRUE TO NOT ERROR THE SCRIPT --[!]--

_G.FromMouse = false   -- If set to true, the tracers will come from the position of your mouse cursor on your screen.
_G.FromCenter = false   -- If set to true, the tracers will come from the center of your screen.
_G.FromBottom = true   -- If set to true, the tracers will come from the bottom of your screen.

_G.TracersVisible = true   -- If set to true then the tracers will be visible and vice versa.
_G.TracerColor = Color3.fromRGB(255, 80, 10)   -- The color that the tracers would appear as.
_G.TracerThickness = 1   -- The thickness of the tracers.
_G.TracerTransparency = 0.7   -- The transparency of the tracers.

_G.ModeSkipKey = Enum.KeyCode.E   -- The key that changes between modes that indicate where will the tracers come from.
_G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the tracers.

_G.OuterGlowColor = Color3.fromRGB(255, 0, 0)  -- Red outer glow color
_G.FillColor = Color3.fromRGB(255, 150, 150)   -- Lighter red fill color

local function CreateESP()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= game.Players.LocalPlayer.Name then
            local TracerLine = Drawing.new("Line")
            local OuterGlow = Drawing.new("Square")
            local BodyFill = Drawing.new("Square")

            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                    local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                    local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                    
                    TracerLine.Thickness = _G.TracerThickness
                    TracerLine.Transparency = _G.TracerTransparency
                    TracerLine.Color = _G.TracerColor

                    if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                        TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    end

                    if OnScreen == true and TracersEnabled then
                        TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                        if _G.TeamCheck == true then 
                            if Players.LocalPlayer.Team ~= v.Team then
                                TracerLine.Visible = _G.TracersVisible
                            else
                                TracerLine.Visible = false
                            end
                        else
                            TracerLine.Visible = _G.TracersVisible
                        end
                        
                        -- Update Outer Glow and Body Fill
                        local Character = workspace:FindFirstChild(v.Name)
                        if Character and Character:FindFirstChild("HumanoidRootPart") then
                            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                            local Head = Character:FindFirstChild("Head")
                            local HRP_Position, HRP_Size = HumanoidRootPart.CFrame, HumanoidRootPart.Size * 1
                            local Head_Position, Head_Size = Head.CFrame, Head.Size * 1
                            local HRP_Vector, HRP_OnScreen = Camera:WorldToViewportPoint(HRP_Position * CFrame.new(0, -HRP_Size.Y, 0).p)
                            local Head_Vector, Head_OnScreen = Camera:WorldToViewportPoint(Head_Position * CFrame.new(0, -Head_Size.Y, 0).p)
                            
                            if HRP_OnScreen and Head_OnScreen then
                                OuterGlow.Visible = true
                                OuterGlow.Color = _G.OuterGlowColor
                                OuterGlow.Thickness = 3
                                OuterGlow.Transparency = 0.7
                                OuterGlow.Size = Vector2.new(30, 60)
                                OuterGlow.Position = Vector2.new(HRP_Vector.X - OuterGlow.Size.X / 2, HRP_Vector.Y - OuterGlow.Size.Y / 2)
                                
                                BodyFill.Visible = true
                                BodyFill.Color = _G.FillColor
                                BodyFill.Transparency = 0.5
                                BodyFill.Size = Vector2.new(28, 58)
                                BodyFill.Position = Vector2.new(HRP_Vector.X - BodyFill.Size.X / 2, HRP_Vector.Y - BodyFill.Size.Y / 2)
                            else
                                OuterGlow.Visible = false
                                BodyFill.Visible = false
                            end
                        else
                            OuterGlow.Visible = false
                            BodyFill.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                        OuterGlow.Visible = false
                        BodyFill.Visible = false
                    end
                else
                    TracerLine.Visible = false
                    OuterGlow.Visible = false
                    BodyFill.Visible = false
                end
            end)

            Players.PlayerRemoving:Connect(function()
                TracerLine.Visible = false
                OuterGlow.Visible = false
                BodyFill.Visible = false
            end)
        end
    end

    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(v)
            if v.Name ~= game.Players.LocalPlayer.Name then
                local TracerLine = Drawing.new("Line")
                local OuterGlow = Drawing.new("Square")
                local BodyFill = Drawing.new("Square")

                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                        local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                        
                        TracerLine.Thickness = _G.TracerThickness
                        TracerLine.Transparency = _G.TracerTransparency
                        TracerLine.Color = _G.TracerColor

                        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end

                        if OnScreen == true and TracersEnabled then
                            TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= Player.Team then
                                    TracerLine.Visible = _G.TracersVisible
                                else
                                    TracerLine.Visible = false
                                end
                            else
                                TracerLine.Visible = _G.TracersVisible
                            end

                            -- Update Outer Glow and Body Fill
                            local Character = workspace:FindFirstChild(Player.Name)
                            if Character and Character:FindFirstChild("HumanoidRootPart") then
                                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                                local Head = Character:FindFirstChild("Head")
                                local HRP_Position, HRP_Size = HumanoidRootPart.CFrame, HumanoidRootPart.Size * 1
                                local Head_Position, Head_Size = Head.CFrame, Head.Size * 1
                                local HRP_Vector, HRP_OnScreen = Camera:WorldToViewportPoint(HRP_Position * CFrame.new(0, -HRP_Size.Y, 0).p)
                                local Head_Vector, Head_OnScreen = Camera:WorldToViewportPoint(Head_Position * CFrame.new(0, -Head_Size.Y, 0).p)
                                
                                if HRP_OnScreen and Head_OnScreen then
                                    OuterGlow.Visible = true
                                    OuterGlow.Color = _G.OuterGlowColor
                                    OuterGlow.Thickness = 3
                                    OuterGlow.Transparency = 0.7
                                    OuterGlow.Size = Vector2.new(30, 60)
                                    OuterGlow.Position = Vector2.new(HRP_Vector.X - OuterGlow.Size.X / 2, HRP_Vector.Y - OuterGlow.Size.Y / 2)
                                    
                                    BodyFill.Visible = true
                                    BodyFill.Color = _G.FillColor
                                    BodyFill.Transparency = 0.5
                                    BodyFill.Size = Vector2.new(28, 58)
                                    BodyFill.Position = Vector2.new(HRP_Vector.X - BodyFill.Size.X / 2, HRP_Vector.Y - BodyFill.Size.Y / 2)
                                else
                                    OuterGlow.Visible = false
                                    BodyFill.Visible = false
                                end
                            else
                                OuterGlow.Visible = false
                                BodyFill.Visible = false
                            end
                        else
                            TracerLine.Visible = false
                            OuterGlow.Visible = false
                            BodyFill.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                        OuterGlow.Visible = false
                        BodyFill.Visible = false
                    end
                end)

                Players.PlayerRemoving:Connect(function()
                    TracerLine.Visible = false
                    OuterGlow.Visible = false
                    BodyFill.Visible = false
                end)
            end
        end)
    end)
end

-- Chat Command Handler
Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]

    if command:lower() == "/keybind" and #args == 2 then
        local keyName = args[2]:upper()
        local newKeybind = Enum.KeyCode[keyName]

        if newKeybind then
            if newKeybind ~= _G.DisableKey and newKeybind ~= _G.ModeSkipKey then
                _G.DisableKey = newKeybind
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Aetherial Hub";
                    Text = "Disable Keybind changed to " .. tostring(newKeybind);
                    Duration = 5;
                })
            elseif newKeybind == _G.DisableKey then
                _G.DisableKey = newKeybind
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Aetherial Hub";
                    Text = "Disable Keybind already set to " .. tostring(newKeybind);
                    Duration = 5;
                })
            elseif newKeybind == _G.ModeSkipKey then
                _G.ModeSkipKey = newKeybind
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Aetherial Hub";
                    Text = "Mode Skip Keybind already set to " .. tostring(newKeybind);
                    Duration = 5;
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Aetherial Hub";
                    Text = "Invalid keybind.";
                    Duration = 5;
                })
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Aetherial Hub";
                Text = "Invalid keybind.";
                Duration = 5;
            })
        end
    elseif command:lower() == "/color" and #args == 2 then
        local colorArgs = string.split(args[2], ",")
        if #colorArgs == 3 then
            local r = tonumber(colorArgs[1])
            local g = tonumber(colorArgs[2])
            local b = tonumber(colorArgs[3])
            
            if r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
                _G.TracerColor = Color3.fromRGB(r, g, b)
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Aetherial Hub";
                    Text = "Tracer color changed to (" .. r .. ", " .. g .. ", " .. b .. ")";
                    Duration = 5;
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Aetherial Hub";
                    Text = "Invalid color values. Please use format R,G,B with values between 0 and 255.";
                    Duration = 5;
                })
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Aetherial Hub";
                Text = "Invalid color format. Please use format R,G,B.";
                Duration = 5;
            })
        end
    end
end)

CreateESP()
