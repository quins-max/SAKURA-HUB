local games = {
    [79268393072444] = "", -- Sell Lemons
    [83645629621104] = "", -- Forsaken
    [124842176624983] = "", -- Overkill
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
