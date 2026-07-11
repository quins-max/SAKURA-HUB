local games = {
    [79268393072444] = "https://raw.githubusercontent.com/quins-max/SAKURA-HUB/refs/heads/main/sell-lemons.lua", -- Sell Lemons
    [83645629621104] = "https://raw.githubusercontent.com/quins-max/SAKURA-HUB/refs/heads/main/forsaken.lua", -- Forsaken
    [124842176624983] = "https://api.luarmor.net/files/v4/loaders/cda71bd445d7ac084a8578493d094fd9.lua", -- Overkill
    [90646044690663] = "https://api.luarmor.net/files/v4/loaders/cda71bd445d7ac084a8578493d094fd9.lua", -- Mobile Overkill
    [4580204640] = "https://api.jnkie.com/api/v1/luascripts/public/32e9d0497bc8b3eda72879cc91960ec150aa0952d055bf779325632e86f144f8/download", -- Survive the Killer B
    [11840234178] = "https://api.jnkie.com/api/v1/luascripts/public/32e9d0497bc8b3eda72879cc91960ec150aa0952d055bf779325632e86f144f8/download", -- Survive the Killer A
    [11840243894] = "https://api.jnkie.com/api/v1/luascripts/public/32e9d0497bc8b3eda72879cc91960ec150aa0952d055bf779325632e86f144f8/download", -- Survive the Killer P
    [155615604] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Prison Life
    [135564683255158] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Prison Life V
    [6516141723] = "https://raw.githubusercontent.com/quins-max/VibeIncDoors/refs/heads/main/ScriptLoader.luau", -- DOORS
    [12308344607] = "https://raw.githubusercontent.com/quins-max/VibeIncDoors/refs/heads/main/ScriptLoader.luau", -- DOORS
    [6839171747] = "https://raw.githubusercontent.com/quins-max/VibeIncDoors/refs/heads/main/ScriptLoader.luau", -- DOORS
}

local currentPlaceId = game.PlaceId

if games[currentPlaceId] then
    local success, err = pcall(function()
        loadstring(game:HttpGet(games[currentPlaceId]))()
    end)
    
    if not success then
        warn("Error: Failed to execute script for this game. " .. tostring(err))
    end
else
    warn("Error: Current Game ID (" .. tostring(currentPlaceId) .. ") is not supported.")
end
