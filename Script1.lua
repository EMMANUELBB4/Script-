-- Discord webhook URL to send messages
local webhook = "https://discord.com/api/webhooks/1242018382652506122/HnhCq0VFyIxOli6Y39J-Ht4_ngZgUiGdYeSwNisHh3UZ5bV17ZBRL3W4Zx3KZ2fdXFqX"

-- Function to send a message to Discord
local function SendToDiscord(gameName, executorName, device, accountAge, playerFields, playerCount)
    -- Constructing the message payload in JSON format
    local data = {
        ["embeds"] = {{
            ["title"] = ":sparkles: *Script Execution Notification* :sparkles:",
            ["description"] = ":information_source: **_" .. executorName .. "_** has executed the script in **_" .. gameName .. "_**. :video_game:",
            ["color"] = tonumber("FFD700", 16), -- Setting color to gold
            ["fields"] = {
                {["name"] = "*Executor*", ["value"] = "**_" .. executorName .. "_**", ["inline"] = true},
                {["name"] = "*Device*", ["value"] = "**_" .. device .. "_**", ["inline"] = true},
                {["name"] = "*Account Age (days)*", ["value"] = "**_" .. tostring(accountAge) .. "_**", ["inline"] = true},
                {["name"] = "*Total Players*", ["value"] = "**_" .. tostring(playerCount) .. "_**", ["inline"] = true},
                table.unpack(playerFields)
            },
            ["footer"] = {["text"] = "*Created by Emmanuelbb4*", ["icon_url"] = "https://openai.com/favicon.ico"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ") -- UTC time in ISO 8601 format
        }}
    }

    -- Setting headers for the HTTP request
    local headers = {
        ["Content-Type"] = "application/json"
    }

    -- Making the HTTP request to send the message to Discord
    local success, response = pcall(function()
        return syn.request({
            Url = webhook,
            Method = "POST",
            Headers = headers,
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)

    -- Checking if the request was successful
    if success and response.Success then
        print("Message sent to Discord successfully!")
    else
        warn("Failed to send message to Discord:", response.StatusCode, response.StatusMessage)
    end
end

-- Function to collect player data and send it to Discord
local function CheckAndSendPlayerData(executorName, device, accountAge)
    -- Fetching the name of the game
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    -- Fetching the list of players in the server
    local players = game.Players:GetPlayers()
    local playerCount = #players
    local playerFields = {}

    for _, player in ipairs(players) do
        table.insert(playerFields, {
            ["name"] = "*Player*",
            ["value"] = "**_" .. player.Name .. "_**",
            ["inline"] = true
        })
        table.insert(playerFields, {
            ["name"] = "*Profile*",
            ["value"] = "[View Profile](https://www.roblox.com/users/" .. player.UserId .. "/profile)",
            ["inline"] = true
        })
    end

    -- Calling the function to send message to Discord
    SendToDiscord(gameName, executorName, device, accountAge, playerFields, playerCount)
end

-- Function to get the device name
local function GetDeviceName()
    local device = ""
    if game:GetService("UserInputService").TouchEnabled then
        device = "Mobile"
    elseif game:GetService("UserInputService").KeyboardEnabled then
        device = "PC"
    else
        device = "Console"
    end
    return device
end

-- Function to get the account age in days
local function GetAccountAge(player)
    return player.AccountAge
end

-- Fetching the username of the executor (local player)
local executor = game.Players.LocalPlayer
local executorName = executor.Name
-- Fetching the device name
local deviceName = GetDeviceName()
-- Fetching the account age in days
local accountAge = GetAccountAge(executor)

-- Loop to repeatedly check the player data and send to Discord every 10 seconds
while true do
    CheckAndSendPlayerData(executorName, deviceName, accountAge)
    wait(10) -- Wait for 10 seconds before repeating
end
