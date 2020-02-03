ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'moteros', Config.MaxInService)
end

-- TriggerEvent('esx_phone:registerNumber', 'biker', _U('alert_biker'), true, true)

TriggerEvent('esx_society:registerSociety', 'moteros', 'Moteros', 'society_moteros', 'society_moteros', 'society_biker', {type = 'public'})


RegisterServerEvent('Banda-Moteros:message')
AddEventHandler('Banda-Moteros:message', function(target, msg)

  --TriggerClientEvent('esx:showNotification', target, msg)
  TriggerClientEvent('mythic_notify:client:SendAlert', target, { type = 'cajanegra', text = msg,length = 10000})

end)


----------------------------ANIMACION CUFF 2.0-----------

RegisterServerEvent('Banda-Moteros1:requestarrest')
AddEventHandler('Banda-Moteros1:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
  _source = source
  --print ("Prueba1")
    TriggerClientEvent('Banda-Moteros1:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('Banda-Moteros1:doarrested', _source)
end)

RegisterServerEvent('Banda-Moteros1:requestrelease')
AddEventHandler('Banda-Moteros1:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('Banda-Moteros1:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('Banda-Moteros1:douncuffing', _source)
end)
----------------------------ANIMACION CUFF 2.0-----------

RegisterServerEvent('Banda-Moteros:handcuff')
AddEventHandler('Banda-Moteros:handcuff', function(target)
  TriggerClientEvent('Banda-Moteros:handcuff', target)
end)

RegisterServerEvent('Banda-Moteros:drag')
AddEventHandler('Banda-Moteros:drag', function(target)
  local _source = source
  TriggerClientEvent('Banda-Moteros:drag', target, _source)
end)

RegisterServerEvent('Banda-Moteros:putInVehicle')
AddEventHandler('Banda-Moteros:putInVehicle', function(target)
  TriggerClientEvent('Banda-Moteros:putInVehicle', target)
end)

RegisterServerEvent('Banda-Moteros:OutVehicle')
AddEventHandler('Banda-Moteros:OutVehicle', function(target)
    TriggerClientEvent('Banda-Moteros:OutVehicle', target)
end)

ESX.RegisterServerCallback('Banda-Moteros:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      =    result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height']

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)



ESX.RegisterServerCallback('Banda-Moteros:getFineList', function(source, cb, category)
  MySQL.Async.fetchAll('SELECT * FROM fine_types_moteros WHERE category = @category', {
    ['@category'] = category
  }, function(fines)
    cb(fines)
  end)
end)

ESX.RegisterServerCallback('Banda-Moteros:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('Banda-Moteros:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_moteros', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)


