local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = players.LocalPlayer

for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        local args = {
            [1] = player
        }
        replicatedStorage.Events.OnDoorHit:FireServer(unpack(args))
    end
end
