-- Universal Loader (Clean, No Key System)
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

-- GitHub repo
local githubUser = "daSSAD5TYG"
local githubRepo = "soullesshub"

-- Base URLs
local baseUrl = `https://raw.githubusercontent.com/${githubUser}/${githubRepo}/refs/heads/main/${game.GameId}/loader.lua`
local base64url = `https://api.github.com/repos/${githubUser}/${githubRepo}/contents/${game.GameId}/loader.lua?ref=main`

-- Function to load game loader
local function loadGameLoader()
	if base64 and base64.decode then
		local succ, err = pcall(function()
			local response = game:HttpGet(base64url)
			local data = HttpService:JSONDecode(response)
			local decoded = base64.decode(data.content:gsub("\n", ""))
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

-- Load Fluent UI (similar to original)
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
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
	})

	local Tabs = {
		Main = Window:AddTab({ Title = "Main", Icon = "app" }),
	}

	-- Buttons
	Tabs.Main:AddButton({
		Title = "Detecting Game ID",
		Description = "Automatically fetch loader for this game",
		Callback = function()
			loadGameLoader()
		end
	})

	Tabs.Main:AddButton({
		Title = "Execute Anyways",
		Description = "Run loader even if no folder exists for this game",
		Callback = function()
			local inputId = game.GameId
			loadGameLoader(inputId)
		end
	})

	Window:SelectTab(1)
end

-- Run loader automatically
loadGameLoader()

-- Teleport support
if queue_on_teleport and not getgenv().SoullessHub then
	getgenv().SoullessHub = true
	client.OnTeleport:Once(function(State)
		if getgenv().AutoExecCloudy then
			queue_on_teleport([[
				getgenv().hookmetamethod = function() end
				loadstring(game:HttpGet("https://raw.githubusercontent.com/daSSAD5TYG/soullesshub/main/Loader.lua"), "SoullessHub")()
			]])
		end
	end)
end


-- Initialize UI
createUI()
