local Hub = ...
local add_page      = Hub.add_page
local add_menu_text = Hub.add_menu_text
local buttonIcons   = Hub.buttonIcons
local PlaceName     = Hub.PlaceName

add_menu_text("PRISON LIFE")
local pl_car = add_page("Car", buttonIcons.Other)

pl_car:add_toggle("Car Speed", false, function()
    local function getVehicleSeat()
        local char = game.Players.LocalPlayer.Character
        if not char then return nil end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum then return nil end
        local vehicleSeat = hum.SeatPart
        return (vehicleSeat and vehicleSeat:IsA("VehicleSeat")) and vehicleSeat or nil
    end

    local cs_chosenVelocity = 0.0075
    local cs_brakevelocity = 0.05

    cs_running = true -- <-- was missing

    task.spawn(function()
        while cs_running do
            task.wait()

            local currentVehicleSeat = getVehicleSeat()
            if currentVehicleSeat then -- <-- guard against nil
                local vsALV = currentVehicleSeat.AssemblyLinearVelocity
                local vsCFRAME = currentVehicleSeat.CFrame
                local vsLOOKVECTOR = vsCFRAME.LookVector
                local vsVELOCITY = Vector3.new(vsALV.X, 0, vsALV.Z)

                local dotVELOCITY = vsVELOCITY:Dot(vsLOOKVECTOR)
                if dotVELOCITY < -1 then
                    currentVehicleSeat.AssemblyLinearVelocity = vsALV * (1 - cs_brakevelocity * 3)
                else
                    -- give it a minimum push so it works from a standstill,
                    -- then apply the multiplier on top
                    local boosted = vsALV + vsLOOKVECTOR * 5
                    currentVehicleSeat.AssemblyLinearVelocity = boosted * Vector3.new(1 + cs_chosenVelocity, 1, 1 + cs_chosenVelocity)
                end
            end
        end
    end)
end, function()
    cs_running = false
end)
