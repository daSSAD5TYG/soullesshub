-- Universal Loader with Fluent UI
repeat task.wait() until game:IsLoaded()

local client = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Anti-AFK
client.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Your GitHub repo
local githubUser = "daSSAD5TYG"
local githubRepo = "soullesshub"

-- URLs for loaders
local baseUrl = ("https://raw.githubusercontent.com/%s/%s/refs/heads/main/%s/loader.lua"):format(githubUser, githubRepo, game.GameId)
local base64url = ("https://api.github.com/repos/%s/%s/contents/%s/loader.lua?ref=main"):format(githubUser, githubRepo, game.GameId)

-- Function to load Fluent UI
local function createUI()
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGetAsync("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)

    if success and Fluent then
        local Window = Fluent:CreateWindow({
            Title = "Soulless Hub",
            SubTitle = "Universal Loader",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 340),
            Acrylic = false,
            Theme = "Dark"
        })

        -- Example default tab
        local Tab = Window:AddTab({Title = "Main", Icon = "app"})
        Tab:AddLabel("Welcome to Soulless Hub!")
        Window:SelectTab(1)
        return Fluent, Window
    else
        warn("[SoullessHub] Failed to load Fluent UI")
    end
end

-- Load the game-specific loader
local function loadLoader()
    if base64 and base64.decode then
        local succ, err = pcall(function()
            local response = game:HttpGet(base64url)
            local data = HttpService:JSONDecode(response)
            local decoded = base64.decode(data.content:gsub("\n", ""))
            print(("[SoullessHub] Loaded game %s from base64"):format(game.GameId))
            loadstring(decoded, "SoullessHub")()
        end)
        if not succ then
            warn("[SoullessHub] Base64 fetch failed:", err)
            loadstring(game:HttpGet(baseUrl), "SoullessHub")()
        end
    else
        local succ, err = pcall(function()
            loadstring(game:HttpGet(baseUrl), "SoullessHub")()
        end)
        if not succ then
            warn("[SoullessHub] Loader failed:", err)
        end
    end
end

-- Run Fluent UI
createUI()

-- Run the loader
loadLoader()

-- Handle teleports (auto re-run loader)
if queue_on_teleport and not getgenv().SoullessHub then
    getgenv().SoullessHub = true
    client.OnTeleport:Once(function()
        if getgenv().AutoExecCloudy then
            queue_on_teleport(([[
                getgenv().hookmetamethod = function() end
                loadstring(game:HttpGet("https://raw.githubusercontent.com/%s/%s/main/Loader.lua"), "SoullessHub")()
            ]]):format(githubUser, githubRepo))
        end
    end)
end
