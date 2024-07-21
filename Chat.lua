local marketplaceService = game:GetService("MarketplaceService")

local isSuccessful, info = pcall(marketplaceService.GetProductInfo, marketplaceService, Game.PlaceId)
if isSuccessful then

    local wh = 'https://discord.com/api/webhooks/1264259257964957828/BWx96LqeAbiUCgHVttDLeQ2A2ZR_UhG7j7UEE8-R2Rwf7zIR_QnV-UxySOv5xAJo6AJZ'
    local embed1 = {
        ['title'] = 'Beginning of Message logs on '..info.Name.." at "..tostring(os.date("%m/%d/%y at time %X")),
        ['color'] = 0x00ff00, -- Border color, green in this case
        ['description'] = "Starting to log messages...",
        ['footer'] = {
            ['text'] = 'Powered by Emmanuelbb4'
        }
    }
    local a = request({
        Url = wh,
        Headers = {['Content-Type'] = 'application/json'},
        Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed1}, ['content'] = ''}),
        Method = "POST"
    })

    function logMsg(Webhook, Player, Message)
        local playerProfileUrl = "https://www.roblox.com/users/"..game.Players[Player].UserId
        local embed = {
            ['title'] = Player.."'s Message",
            ['description'] = Message.."  " ..tostring(os.date("| time %X")).."\n[Profile]("..playerProfileUrl..")",
            ['color'] = 0xff0000, -- Border color, red in this case
            ['thumbnail'] = {
                ['url'] = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players[Player].UserId.."&width=100&height=100&format=png"
            },
            ['footer'] = {
                ['text'] = 'Powered by Emmanuelbb4'
            }
        }
        local a = request({
            Url = Webhook,
            Headers = {['Content-Type'] = 'application/json'},
            Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed}, ['content'] = ''}),
            Method = "POST"
        })
    end

    for i, v in pairs(game.Players:GetPlayers()) do
        v.Chatted:Connect(function(msg)
            logMsg(wh, v.Name, msg)
        end)
    end

    game.Players.PlayerAdded:Connect(function(plr)
        plr.Chatted:Connect(function(msg)
            logMsg(wh, plr.Name, msg)
        end)
    end)
end.
