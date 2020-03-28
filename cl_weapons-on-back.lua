ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local PlayerData = ESX.GetPlayerData()
local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      ["w_me_bat"] = "WEAPON_BAT",
      ["prop_ld_jerrycan_01"] = "WEAPON_PETROLCAN",
      ["w_ar_carbinerifle"] = "WEAPON_CARBINERIFLE",
      ["w_ar_assaultrifle"] = "WEAPON_ASSAULTRIFLE",
      ["w_ar_specialcarbine"] = "WEAPON_SPECIALCARBINE",
      ["w_ar_bullpuprifle"] = "WEAPON_BULLPUPRIFLE",
      ["w_ar_advancedrifle"] = "WEAPON_ADVANCEDRIFLE",
      ["w_sb_microsmg"] = "WEAPON_MICROSMG",
      ["w_sb_assaultsmg"] = "WEAPON_ASSAULTSMG",
      ["w_sb_smg"] = "WEAPON_MICROSMG",
      ["w_sb_smgmk2"] = "WEAPON_MINISMG",
      ["w_sb_gusenberg"] = "WEAPON_SMG",
      ["w_sr_sniperrifle"] = "WEAPON_SNIPERRIFLE",
      ["w_sg_assaultshotgun"] = "WEAPON_ASSAULTSHOTGUN",
      ["w_sg_bullpupshotgun"] = "WEAPON_BULLPUPSHOTGUN",
      ["w_sg_pumpshotgun"] = "WEAPON_PUMPSHOTGUN",
      ["w_ar_musket"] = "WEAPON_MUSKET",
      ["w_sg_heavyshotgun"] = "WEAPON_HEAVYSHOTGUN"
    }
}

local attached_weapons = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(3000)
    local me = GetPlayerPed(-1)
    for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
      local item = GetInventoryItem(wep_hash)
      if item and item.count > 0 then
        if not attached_weapons[wep_name] and not (GetSelectedPedWeapon(me) == GetHashKey(wep_hash)) then
          AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
        elseif (GetSelectedPedWeapon(me) == GetHashKey(attached_weapons[wep_name].hash)) and attached_weapons[wep_name] ~= nil then -- equipped or not in weapon wheel
          DeleteObject(attached_weapons[wep_name].handle)
          attached_weapons[wep_name] = nil
        end
      elseif attached_weapons[wep_name] then
        if DoesEntityExist(attached_weapons[wep_name].handle) then
          DeleteObject(attached_weapons[wep_name].handle)
          attached_weapons[wep_name] = nil
        end
      end
    end
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
    Wait(0)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then 
    x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 
  end
  if attachModel == "prop_ld_jerrycan_01" then 
    x = x + 0.3 
  end
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

function GetInventoryItem(name)
  while not PlayerData.inventory do
    Citizen.Wait(0)
  end
  local inventory = PlayerData.inventory
  for i=1, #inventory, 1 do
    if inventory[i].name == name and inventory[i].count >= 1 then
      return inventory[i]
    end
  end
  return false
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
  Citizen.Wait(100)
  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(name, count)
  if string.find(name, "WEAPON_", 1) ~= nil then
    Citizen.Wait(100)
    PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(name, count)
  if string.find(name, "WEAPON_", 1) ~= nil then
    Citizen.Wait(100)
    PlayerData = ESX.GetPlayerData()
  end
end)