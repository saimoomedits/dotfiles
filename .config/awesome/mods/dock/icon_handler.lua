-----------------------------------------------------
-- Helper to get icons from a program/program name --
-----------------------------------------------------
-- created by Crylia
-- modified by saimoomedits

-- this handler will be improved later

local icon_cache = {}

local function Get_icon(theme, client, program_string, class_string, is_steam)

  client = client or nil
  program_string = program_string or nil
  class_string = class_string or nil
  is_steam = is_steam or nil

  if theme and (client or program_string or class_string) then
    local clientName
    if is_steam then
      clientName = "steam_icon_" .. tostring(client) .. ".svg"
    elseif client then
      if client.class then
        clientName = string.lower(client.class:gsub(" ", "")) .. ".svg"
      elseif client.name then
        clientName = string.lower(client.name:gsub(" ", "")) .. ".svg"
      else
        if client.icon then
          return client.icon
        else
          return "/usr/share/icons/Crule/apps/scalable/default-application.svg"
        end
      end
    else
      if program_string then
        clientName = program_string .. ".svg"
      else
        clientName = class_string .. ".svg"
      end
    end

    for index, icon in ipairs(icon_cache) do
      if icon:match(clientName) then
        return icon
      end
    end

        local iconDir = "/usr/share/icons/" .. theme .. "/apps/scalable/"
      local ioStream = io.open(iconDir .. clientName, "r")
      if ioStream ~= nil then
        icon_cache[#icon_cache + 1] = iconDir .. clientName
        return iconDir .. clientName
      else
        clientName = clientName:gsub("^%l", string.upper)
        iconDir = "/usr/share/icons/" .. theme .. "/apps/scalable/"
        ioStream = io.open(iconDir .. clientName, "r")
        if ioStream ~= nil then
          icon_cache[#icon_cache + 1] = iconDir .. clientName
          return iconDir .. clientName
        elseif not class_string then
          return "/usr/share/icons/Crule/apps/scalable/default-application.svg"
        else
          clientName = class_string .. ".svg"
          iconDir = "/usr/share/icons/" .. theme .. "/apps/scalable/"
          ioStream = io.open(iconDir .. clientName, "r")
          if ioStream ~= nil then
            icon_cache[#icon_cache + 1] = iconDir .. clientName
            return iconDir .. clientName
          else
            return "/usr/share/icons/Crule/apps/scalable/default-application.svg"
          end
        end
      end
    end
    if client then
        return "/usr/share/icons/Crule/Crule/apps/scalable/default-application.svg"
    end
end


return Get_icon