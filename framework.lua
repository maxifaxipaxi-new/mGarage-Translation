Core = {}

local FrameWorks = {
    esx = (GetResourceState("es_extended") == "started" and 'esx'),
    ox = (GetResourceState("ox_core") == "started" and 'ox')
}

Core.FrameWork = FrameWorks.esx or FrameWorks.ox or 'standalone'

ESX, OX = nil, nil


if Core.FrameWork == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Core.FrameWork == 'ox' then

end

if not IsDuplicityVersion() then -- client side
    if Core.FrameWork == "esx" then
        RegisterNetEvent('esx:setJob', function(job)
            ESX.PlayerData.job = job
        end)
    end

    function Core:GetPlayerJob()
        if Core.FrameWork == "esx" then
            local Job = ESX.PlayerData.job
            return { name = Job.name, grade = Job.grade, gradeName = Job.grade_name }
        elseif Core.FrameWork == "ox" then

        elseif Core.FrameWork == "standalone" then
            -- Your custom logic for standalone framework
            return { name = '', grade = '', gradeName = '' }
        end
    end

    function Core:PlayerGroup()
        if Core.FrameWork == "esx" then
            return LocalPlayer.state.group
        elseif Core.FrameWork == "ox" then

        elseif Core.FrameWork == "standalone" then
            -- Your custom logic for standalone framework
            return ''
        end
    end

    function Core:GetPlayerMetadata()
        if Core.FrameWork == "esx" then
            return ESX.PlayerData.metadata
        elseif Core.FrameWork == "ox" then

        elseif Core.FrameWork == "standalone" then
            -- Your custom logic for standalone frameworkr
            return {}
        end
    end

    ---@param callback function
    function Core:ClienPlayerLoad(callback)
        if Core.FrameWork == "esx" then
            RegisterNetEvent('esx:playerLoaded')
            AddEventHandler('esx:playerLoaded', function(xPlayer)
                ESX.PlayerData = xPlayer
                callback(xPlayer)
            end)
        elseif Core.FrameWork == "ox" then

        elseif Core.FrameWork == "standalone" then

        end
    end
else -- server side
    --- @class Player
    --- @field clientEvent function
    --- @field PlayerFunctions function
    --- @field identifier string
    --- @field source number|integer|string
    --- @field getName function
    --- @field getMoney function
    --- @field RemoveMoney function
    --- @field GetIdentifier function
    --- @field isAdmin function
    --- @field Coords function
    --- @field Notify function
    --- @field GetJob function
    --- @field setMeta function
    --- @field clearMeta function
    --- @field getMeta function

    --- @param src number
    --- @return Player|boolean
    function Core:Player(src)
        self = {}

        self.clientEvent = function(name, ...)
            TriggerClientEvent(name, src, ...)
        end

        self.PlayerFunctions = function()
            if Core.FrameWork == "esx" then
                return ESX.GetPlayerFromId(src)
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                -- Your custom logic for standalone frameworkr
            end
        end

        local Player = self.PlayerFunctions()

        if not Player then return false end


        self.GetIdentifier = function()
            if Core.FrameWork == "esx" then
                return Player.identifier
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                return GetPlayerIdentifierByType(src, 'license')
            end
            return false
        end


        self.getName = function()
            if Core.FrameWork == "esx" then
                return Player.getName()
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                return GetPlayerName(src)
            end
            return false
        end

        self.getMoney = function(account)
            if Core.FrameWork == "esx" then
                local money = Player.getAccount(account)
                return { money = money.money }
            elseif Core.FrameWork == "ox" then
            elseif Core.FrameWork == "standalone" then
                return { money = 0 }
            end
        end

        self.RemoveMoney = function(account, amount)
            if Core.FrameWork == "esx" then
                return Player.removeAccountMoney(account, amount)
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                return true
            end
        end

        self.isAdmin = function()
            if Core.FrameWork == "esx" then
                return (Player.getGroup() == 'admin')
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                return false
            end
        end

        self.Coords = function()
            local entity = GetPlayerPed(src)
            if not entity then return end
            local coords, heading = GetEntityCoords(entity), GetEntityHeading(entity)
            return { x = coords.x, y = coords.y, z = coords.z, w = heading }
        end

        self.Notify = function(data)
            self.clientEvent('mGarage:notify', data)
        end


        self.GetJob = function()
            if Core.FrameWork == "esx" then
                local job = Player.getJob()
                return { name = job.name, grade = job.grade, gradeName = job.grade_name }
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                return { name = '', grade = '', gradeName = '' }
            end

            return false
        end

        self.getMeta = function(key)
            if Core.FrameWork == "esx" then
                return Player.getMeta(key)
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then
                return {}
            end

            return false
        end

        self.setMeta = function(key, data)
            if Core.FrameWork == "esx" then
                Player.setMeta(key, data)
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then

            end

            return false
        end

        self.clearMeta = function(key)
            if Core.FrameWork == "esx" then
                Player.clearMeta(key)
            elseif Core.FrameWork == "ox" then

            elseif Core.FrameWork == "standalone" then

            end

            return false
        end

        self.identifier = self.GetIdentifier()

        self.source = src

        return self
    end

    --- Set society mone
    ---@param society string
    ---@param ammount number
    function Core:SetSotcietyMoney(society, ammount)
        if Core.FrameWork == "esx" then
            TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
                account.addMoney(ammount)
            end)
        elseif Core.FrameWork == "ox" then

        elseif Core.FrameWork == "standalone" then
            return true
        end
    end

    ---@param callback function
    function Core:ServerPlayerLoad(callback)
        if Core.FrameWork == "esx" then
            RegisterNetEvent('esx:playerLoaded', function(sourcePlayer, xPlayer, isNew)
                callback(sourcePlayer, xPlayer, isNew)
            end)
        elseif Core.FrameWork == "ox" then

        elseif Core.FrameWork == "standalone" then

        end
    end
end


return Core
