-- This script will highlight all players and allow you to see them through walls.
-- It's a local script, meaning it will only affect your player's view.

-- Get the local player
local localPlayer = game.Players.LocalPlayer

-- Function to highlight a player
local function highlightPlayer(player)
    -- Check if the player is the local player
    if player == localPlayer then
        return  -- Don't highlight the local player
    end

    -- Find the character of the player
    local character = player.Character
    if not character then
        return  -- Player's character doesn't exist
    end

    -- Check if the player already has a highlight
    local existingHighlight = character:FindFirstChild("PlayerHighlight")
    if existingHighlight then
        return -- Already highlighted
    end

    -- Create a new highlight
    local highlight = Instance.new("Highlight", character)
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = Color3.new(1, 0, 0) -- Red color
    highlight.OutlineColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
end

-- Function to remove highlight from a player
local function removeHighlight(player)
    local character = player.Character
    if not character then
        return
    end
    local highlight = character:FindFirstChild("PlayerHighlight")
    if highlight then
        highlight:Destroy()
    end
end

-- Highlight existing players
for _, player in pairs(game.Players:GetPlayers()) do
    highlightPlayer(player)
end

-- Connect to the PlayerAdded event to highlight new players
game.Players.PlayerAdded:Connect(highlightPlayer)

-- Connect to the PlayerRemoving event to remove highlights when players leave
game.Players.PlayerRemoving:Connect(removeHighlight)

-- Optional:  A more robust method to ensure highlights are applied even if the character respawns.
local function onCharacterAdded(character)
    local player = game.Players:GetPlayerFromCharacter(character)
    if player and player ~= localPlayer then
        -- Check for existing highlight and create if it doesn't exist.
        local existingHighlight = character:FindFirstChild("PlayerHighlight")
        if not existingHighlight then
            local highlight = Instance.new("Highlight", character)
            highlight.Name = "PlayerHighlight"
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
        end
    end
end

-- Apply highlight on character added (for respawns)
game.Players.PlayerAdded:Connect(function(player)
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end)
