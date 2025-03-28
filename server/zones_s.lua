MySQL.query([[
    CREATE TABLE IF NOT EXISTS `mgarages` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(50) NOT NULL,
        `owner` varchar(60) DEFAULT NULL,
        `garage` longtext DEFAULT NULL,
        PRIMARY KEY (`id`)
    )
]])

local QueryZone = {
    GetZones = 'SELECT * FROM mgarages',
    Exist = 'SELECT * FROM mgarages WHERE name = ?',
    AddNew = 'INSERT INTO mgarages (name, garage) VALUES (?, ?)',
    Delete = 'DELETE FROM mgarages WHERE id = ?',
    Update = 'UPDATE mgarages SET garage = ? WHERE id = ?'
}


lib.callback.register('mGarage:GarageZones', function(source, action, data)
    if action == 'getZones' then
        return MySQL.query.await('SELECT * FROM mgarages')
    end

    local player = Core:Player(source)

    if Core.FrameWork ~= 'qbx' and not player.isAdmin() then return false end

    if action == 'create' then
        local zonaExist = MySQL.scalar.await(QueryZone.Exist, { data.name })
        if zonaExist then
            player.Notify({
                title = locale('GarageCreate1'),
                icon = 'database',
                description = locale('GarageCreate4', data.name),
                type = 'error'
            })

            return false
        end

        data.id = MySQL.insert.await(QueryZone.AddNew, { data.name, json.encode(data) })

        if data.id then
            player.Notify({
                title = locale('GarageCreate1'),
                icon = 'database',
                description = locale('GarageCreate5', data.name),
                type = 'success'
            })

            TriggerClientEvent('mGarage:Zone', -1, 'add', data)
        end
        return data.id
    elseif action == 'delete' then
        local db = MySQL.update.await(QueryZone.Delete, { data.id })
        if db then
            player.Notify({
                title = locale('GarageCreate2'),
                icon = 'database',
                description = locale('GarageCreate6', data.name),
                type = 'success'
            })

            TriggerClientEvent('mGarage:Zone', -1, 'delete', data.id)
        end
        return db
    elseif action == 'update' then
        local db = MySQL.update.await(QueryZone.Update, { json.encode(data), data.id })
        if db then
            player.Notify({
                title = locale('GarageCreate3'),
                icon = 'database',
                description = locale('GarageCreate7', data.name),
                type = 'success'
            })

            TriggerClientEvent('mGarage:Zone', -1, 'update', data)
        end
        return db
    end
end)


lib.addCommand('mgarage', {
    help = '[ mGarage ] Create | Edit  GARAGES',
    restricted = Config.CommandGroup
}, function(source)
    local Player = Core:Player(source)
    if not Player.isAdmin() then return end
    Player.clientEvent('mGarage:editcreate', true)
end)
