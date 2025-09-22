-- Universal Loader with Fluent UI + Execute Buttons
repeat task.wait() until game:IsLoaded()

local client = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Anti-AFK
client.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- GitHub repo
local githubUser = "daSSAD5TYG"
local githubRepo = "soullesshub"

local function loadGameLoader(gameId)
    local baseUrl = ("https://raw.githubusercontent.com/%s/%s/refs/heads/main/%s/loader.lua"):format(githubUser, githubRepo, gameId)
    local base64url = ("https://api.github.com/repos/%s/%s/contents/%s/loader.lua?ref=main"):format(githubUser, githubRepo, gameId)

    if base64 and base64.decode then
        local succ, err = pcall(function()
            local response = game:HttpGet(base64url)
            local data = HttpService:JSONDecode(response)
            local decoded = base64.decode(data.content:gsub("\n", ""))
            print(("[SoullessHub] Loaded game %s from base64"):format(gameId))
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

-- Load Fluent UI
local function createUI()
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGetAsync("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)

    if not success or not Fluent then
        warn("[SoullessHub] Failed to load Fluent UI")
        return
    end

    local Window = Fluent:CreateWindow({
        Title = "Soulless Hub",
        SubTitle = "Universal Loader",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 340),
        Acrylic = false,
        Theme = "Dark"
    })

    local Tab = Window:AddTab({Title = "Main", Icon = "app"})
    Tab:AddLabel("Welcome to Soulless Hub!")

    -- Button: Detect Game ID
    Tab:AddButton({
        Title = "Detecting Game ID",
        Description = "Automatically fetches loader for this game",
        Callback = function()
            loadGameLoader(game.GameId)
        end
    })

    -- Button: Execute Anyways
    Tab:AddButton({
        Title = "Execute Anyways",
        Description = "Run loader regardless of folder",
        Callback = function()
            local inputId = game.GameId
            local prompt = Instance.new("ScreenGui")
            inputId = tonumber(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Prompt"):GetAttribute("GameId")) or game.GameId
            loadGameLoader(inputId)
        end
    })

    Window:SelectTab(1)
end

-- Initialize UI
createUI()
