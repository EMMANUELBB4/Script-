local marketplaceService = game:GetService("MarketplaceService")
local httpService = game:GetService("HttpService")
local players = game:GetService("Players")

local wh = 'https://discord.com/api/webhooks/1257679509977567335/vMS8pQFC9CdV26yQlJQYI6qnAUexManB7hRn6hNV_mMIauhwarYOPlizG7y9E0IyjFcQ'

local function sendToWebhook(embed)
    local success, err = pcall(function()
        request({
            Url = wh,
            Headers = {['Content-Type'] = 'application/json'},
            Body = httpService:JSONEncode({['embeds'] = {embed}, ['content'] = ''}),
            Method = "POST"
        })
    end)
    if not success then
        warn("Failed to send message to webhook: "..err)
    end
end

local function getPlayerList()
    local playerList = {}
    for _, player in ipairs(players:GetPlayers()) do
        local age = player.AccountAge -- Get player's account age in days
        table.insert(playerList, {
            ['name'] = player.Name,
            ['value'] = "[View Profile](https://www.roblox.com/users/" .. player.UserId .. "/profile)\nAge: " .. age .. " days",
            ['inline'] = true
        })
    end
    return playerList
end

local function sendPlayerList()
    local embed = {
        ['title'] = 'Player List',
        ['fields'] = getPlayerList(),
        ['timestamp'] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    sendToWebhook(embed)
end

local function initialize()
    local isSuccessful, info = pcall(marketplaceService.GetProductInfo, marketplaceService, game.PlaceId)
    if isSuccessful then
        local embed1 = {
            ['title'] = 'Player List for '..info.Name,
            ['description'] = 'List of players in the game as of ' .. tostring(os.date("%m/%d/%y at time %X")),
            ['timestamp'] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
        sendToWebhook(embed1)
        sendPlayerList()
    else
        warn("Failed to get game info: "..info)
    end

    players.PlayerAdded:Connect(function(player)
        sendPlayerList()
    end)

    players.PlayerRemoving:Connect(function(player)
        sendPlayerList()
    end)
end

initialize()
