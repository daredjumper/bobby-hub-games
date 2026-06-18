local Hub = ...
local add_page      = Hub.add_page
local add_menu_text = Hub.add_menu_text
local buttonIcons   = Hub.buttonIcons
local PlaceName     = Hub.PlaceName

add_menu_text("Pillars of Fortune")

local pof = add_page("Player", buttonIcons.Other)

local ac = false
pof:add_toggle("Autoclicker", false, function()
    ac = true
    task.spawn(function()
      if game:GetService("Players").LocalPlayer.Character then
          while ac do
              task.wait()
              for _, child in ipairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                  if string.find(child.Name, "Sword") or string.find(child.Name, "sword") then
                      child:Activate()
                  end
              end
          end
      end
    end)
end, function()
    ac = false
end)
