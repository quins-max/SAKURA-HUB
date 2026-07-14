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
    [17625359962] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- RIVALS
    [129604661913557] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- RIVALS
    [133215910299950] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- RIVALS
    [117398147513099] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- RIVALS
    [18126510175] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- RIVALS
    [71874690745115] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- RIVALS
    [286090429] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Arsenal
    [79137385850056] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Arsenal
    [112464274410705] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Arsenal
    [95645135481640] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Arsenal
    [2753915549] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [73902483975735] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [4442272183] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [79091703265657] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [7449423635] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [100117331123089] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [85211729168715] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [113741252407134] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [114279672983750] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [117896981438898] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [76401440271920] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [95165932064349] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [92968389658553] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [101151419317285] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [122478697296975] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Blox Fruits
    [16732694052] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Fisch
    [99519129453387] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Fisch
    [142823291] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- MM2
    [2788229376] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Da Hood
    [7213786345] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Da Hood
    [83022801532074] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Da Hood
    [920587237] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Adopt Me
    [132388544979740] = "https://preciseware-loader.precisewarecdn.workers.dev/files/v3/loaders/68fca8c14980400ea3afe0c41e64a646fg3452/b9d81f7a4c6e4a67b1e77c92b8df19aa.lua", -- Adopt Me
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
