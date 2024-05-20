-- Discord webhook URL to send messages
local webhook = "https://discord.com/api/webhooks/1242018382652506122/HnhCq0VFyIxOli6Y39J-Ht4_ngZgUiGdYeSwNisHh3UZ5bV17ZBRL3W4Zx3KZ2fdXFqX"

-- Function to send a message to Discord
function SendToDiscord(username, gameName, profileLink, avatarUrl)
    -- Constructing the message payload in JSON format
    local data = {
        ["embeds"] = {{
            ["title"] = ":sparkles: Script Execution :sparkles:",
            ["description"] = ":information_source: **" .. username .. "** has executed the script in **" .. gameName .. "**. :video_game:",
            ["color"] = tonumber("FFD700", 16), -- Setting color to gold
            ["fields"] = {
                {["name"] = "Roblox Profile", ["value"] = "[View Profile](" .. profileLink .. ")", ["inline"] = true},
                {["name"] = "Execution Time", ["value"] = os.date("%Y-%m-%d %H:%M:%S"), ["inline"] = true}
            },
            ["author"] = {
                ["name"] = username,
                ["icon_url"] = avatarUrl
            },
            ["thumbnail"] = {["url"] = avatarUrl},
            ["footer"] = {["text"] = "Created by Emmanuelbb4", ["icon_url"] = "https://openai.com/favicon.ico"},
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

-- Fetching username of the local player
local username = game.Players.LocalPlayer.Name
-- Fetching name of the game
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
-- Fetching user ID of the local player
local userId = game.Players.LocalPlayer.UserId
-- Constructing the link to the user's Roblox profile
local profileLink = "https://www.roblox.com/users/" .. userId .. "/profile"
-- Fetching the avatar URL of the local player
local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
-- Calling the function to send message to Discord
SendToDiscord(username, gameName, profileLink, avatarUrl)
