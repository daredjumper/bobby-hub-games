local Hub = ...
local add_page      = Hub.add_page
local add_menu_text = Hub.add_menu_text
local buttonIcons   = Hub.buttonIcons
local PlaceName     = Hub.PlaceName

add_menu_text(PlaceName)

add_menu_text(PlaceName)


local mm = add_page("Player", buttonIcons.Other)
mm:add_hint("MACE")

local equipSignal = nil
local unequipSignal = nil
mm:add_toggle("Large Hitbox", false, function()
    local owner = game.Players.LocalPlayer
    local loop = false

    local function applyHitbox(mace)
        if equipSignal then equipSignal:Disconnect() end
        if unequipSignal then unequipSignal:Disconnect() end

        equipSignal = mace.Equipped:Connect(function()
            loop = true
            if mace:FindFirstChild("Hitbox") then
                mace.Hitbox.Size = Vector3.new(35,35,35)
            end
            while loop do
                task.wait()
                local toolHitboxes = workspace:FindFirstChild("_ToolHitboxes")
                if toolHitboxes then
                    for _, hb in pairs(toolHitboxes:GetChildren()) do
                        hb.Size = Vector3.new(35,35,35)
                    end
                end
            end
        end)

        unequipSignal = mace.Unequipped:Connect(function()
            loop = false
        end)
    end

    local function findAndHook()
        local mace = owner.Backpack:FindFirstChild("Mace") or owner.Character and owner.Character:FindFirstChild("Mace")
        if mace then
            applyHitbox(mace)
            return
        end

        -- Watch Backpack and Character for Mace appearing
        maceWatchBackpack = owner.Backpack.ChildAdded:Connect(function(child)
            if child.Name == "Mace" then
                applyHitbox(child)
                maceWatchBackpack:Disconnect()
                maceWatchBackpack = nil
            end
        end)

        maceWatchChar = owner.Character and owner.Character.ChildAdded:Connect(function(child)
            if child.Name == "Mace" then
                applyHitbox(child)
                if maceWatchChar then maceWatchChar:Disconnect() maceWatchChar = nil end
            end
        end)
    end

    findAndHook()

    -- Also re-hook if character respawns
    charSignal = owner.CharacterAdded:Connect(function(char)
        maceWatchChar = char.ChildAdded:Connect(function(child)
            if child.Name == "Mace" then
                applyHitbox(child)
                if maceWatchChar then maceWatchChar:Disconnect() maceWatchChar = nil end
            end
        end)
    end)

end, function()
    local owner = game.Players.LocalPlayer
    loop = false
    if equipSignal then equipSignal:Disconnect() equipSignal = nil end
    if unequipSignal then unequipSignal:Disconnect() unequipSignal = nil end
    if maceWatchBackpack then maceWatchBackpack:Disconnect() maceWatchBackpack = nil end
    if maceWatchChar then maceWatchChar:Disconnect() maceWatchChar = nil end
    if charSignal then charSignal:Disconnect() charSignal = nil end

    local mace = owner.Backpack:FindFirstChild("Mace") or owner.Character and owner.Character:FindFirstChild("Mace")
    local orig = Vector3.new(7.59999942779541, 6.650000095367432, 10.09999942779541)
    if mace and mace:FindFirstChild("Hitbox") then
        mace.Hitbox.Size = orig
    end
    local toolHitboxes = workspace:FindFirstChild("_ToolHitboxes")
    if toolHitboxes then
        for _, hb in pairs(toolHitboxes:GetChildren()) do
            hb.Size = orig
        end
    end
end)
