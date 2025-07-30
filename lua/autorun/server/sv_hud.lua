if (SERVER) then
    util.AddNetworkString('LocalPlayer')
    util.AddNetworkString('CheckULXStatus')
    util.AddNetworkString('CheckPlayerULXPermissions')

    net.Receive('LocalPlayer', function(len, player)
        local ULXStatus = istable(ULib)

        net.Start('CheckULXStatus')
            net.WriteBool(ULXStatus)
        net.Send(player)

        if (not ULXStatus) then
            return
        end

        local ULXPlayerPermisions = {
            Goto = false,
            Teleport = false,
            MuteVoice = false,
            UnMuteVoice = false,
            MuteChat = false,
            UnMuteChat = false,
            Kill = false,
            Kick = false,
            Ban = false
        }
        if (ULib.ucl.query(player, "ulx goto")) then
            ULXPlayerPermisions.Goto = true
        end
        if (ULib.ucl.query(player, "ulx bring")) then
            ULXPlayerPermisions.Teleport = true
        end
        if (ULib.ucl.query(player, "ulx gag")) then
            ULXPlayerPermisions.MuteChat = true
        end
        if (ULib.ucl.query(player, "ulx ungag")) then
            ULXPlayerPermisions.UnMuteChat = true
        end
        if (ULib.ucl.query(player, "ulx mute")) then
            ULXPlayerPermisions.MuteVoice = true
        end
        if (ULib.ucl.query(player, "ulx unmute")) then
            ULXPlayerPermisions.UnMuteVoice = true
        end
        if (ULib.ucl.query(player, "ulx slay")) then
            ULXPlayerPermisions.Kill = true
        end
        if (ULib.ucl.query(player, "ulx kick")) then
            ULXPlayerPermisions.Kick = true
        end
        if (ULib.ucl.query(player, "ulx banid")) then
            ULXPlayerPermisions.Ban = true
        end

        net.Start("CheckPlayerULXPermissions")
            net.WriteTable(ULXPlayerPermisions)
        net.Send(player)
    end)
end
