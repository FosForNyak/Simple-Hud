if (CLIENT) then
	local PanelColor = Color(0, 0, 0, 0)
	local LeftPanelColor = Color(27, 27, 27)
	local RightPanelColor = Color(30, 30, 30)
	local PlayerLineColor = Color(42, 42, 42)
	local LightTextColor = Color(240, 240, 240)
	local DarkTextColor = Color(160, 160, 160)

	local BigFontName = 'BigText'
	local SmallFontName = 'SmallText'

	function TransformSize(ScreenWidth, ScreenHeight, Element, Orientation)
		local WProcent = ScreenWidth / 1920
		local HProcent = ScreenHeight / 1080
		local SProcent = math.sqrt((ScreenWidth * ScreenHeight) / (2073600))

		local result

		if (ScreenWidth or ScreenHeight >= 0) then
			if (Hook or Element != nil) then
				if (Orientation == width) then
					result = math.Round(Element * WProcent)
				elseif (Orientation == height) then
					result = math.Round(Element * HProcent)
				elseif (Orientation == all)  then
					result = math.Round(Element * SProcent)
				else
					print('Orientation are wrong!')
				end
			else
				print('Hook or Element are wrong!')
			end
		else
			print('ScreenWidth or ScreenHeight are wrong!')
		end

		return result
	end

	function PlayerContexMenu(lpl, pl)
		local ContexMenu = DermaMenu()

		ContexMenu:AddOption("Copy Name", function()
			SetClipboardText(pl:Name())
		end)

		ContexMenu:AddOption("Copy UserID", function()
			SetClipboardText(pl:UserID())
		end)

		ContexMenu:AddOption("Copy SteamID", function()
			SetClipboardText(pl:SteamID())
		end)

		if (lpl:IsListenServerHost()) then
			ContexMenu:AddSpacer()

			ContexMenu:AddOption("Kick player", function()
				lpl:ConCommand(string.format("kickid %s You are kicked from the server\n", pl:SteamID()))
			end)

			ContexMenu:AddOption("Ban player", function()
				lpl:ConCommand(string.format("banid 0 %s\n", pl:UserID()))
				SetClipboardText(pl:SteamID())
			end)
		else
			if (LocalPlayer() != nil) then
				net.Start('LocalPlayer')
					net.WritePlayer(LocalPlayer())
				net.SendToServer()

				net.Receive('CheckULXStatus', function()
					ULXIsStatus = net.ReadBool()
				end)

				if (ULXIsStatus == true) then
					net.Receive('CheckPlayerULXPermissions', function()
						ULXPlayerPermisions = net.ReadTable()
					end)

					if (istable(ULXPlayerPermisions) == true) then
						ContexMenu:AddSpacer()

						if (ULXPlayerPermisions['Goto'] == true) then
							ContexMenu:AddOption("Goto", function()
								lpl:ConCommand(string.format("say !goto %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['Teleport'] == true) then
							ContexMenu:AddOption("Teleport", function()
								lpl:ConCommand(string.format("say !bring %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['MuteVoice'] == true) then
							ContexMenu:AddOption("Mute voice", function()
								lpl:ConCommand(string.format("say !gag %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['UnMuteVoice'] == true) then
							ContexMenu:AddOption("Unmute voice", function()
								lpl:ConCommand(string.format("say !ungag %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['MuteChat'] == true) then
							ContexMenu:AddOption("Mute chat", function()
								lpl:ConCommand(string.format("say !mute %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['UnMuteChat'] == true) then
							ContexMenu:AddOption("Unmute chat", function()
								lpl:ConCommand(string.format("say !unmute %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['Kill'] == true) then
							ContexMenu:AddOption("Kill", function()
								lpl:ConCommand(string.format("say !slay %s\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['Kick'] == true) then
							ContexMenu:AddOption("Kick", function()
								lpl:ConCommand(string.format("say !kick %s You are kicked from the server\n", pl:SteamID()))
							end)
						end
						if (ULXPlayerPermisions['Ban'] == true) then
							ContexMenu:AddOption("Ban", function()
								lpl:ConCommand(string.format("!ban 0 %s You are banned on this server\n", pl:SteamID()))
							end)
						end
					end
				end
			end
		end

		ContexMenu:Open()
	end

	-- CONFIG: All configuration settings should be made in 1920 x 1080 resolution --
	local Config_TabWidth = 1200
	local Config_TabHight = 810
	local Config_LeftPanelWidth = 360
	local Config_RightPanelWidth = 840
	local Config_LocalUserImageSize = 128
	local Config_OtherPlayerLineHight = 65
	local Config_OtherPlayerImageSize = 48

	---  WHEN TAB IS OPEN ---
	hook.Add('ScoreboardShow', 'TabIsOpen', function()
		surface.CreateFont('BigText', {
			font = 'Trebuchet24',
			size = ScreenScale(10),
			weight = 500
		})

		surface.CreateFont('SmallText', {
			font = 'Trebuchet18',
			size = ScreenScale(7),
			weight = 500
		})

		ScreenWidth = ScrW()
		ScreenHeight = ScrH()

		Transformded_TabWidth = TransformSize(ScreenWidth, ScreenHeight, Config_TabWidth, width)
		Transformded_TabHight = TransformSize(ScreenWidth, ScreenHeight, Config_TabHight, hight)
		Transformded_LeftPanelWidth = TransformSize(ScreenWidth, ScreenHeight, Config_LeftPanelWidth, width)
		Transformded_RightPanelWidth = TransformSize(ScreenWidth, ScreenHeight, Config_RightPanelWidth, width)
		Transformded_LocalUserImageSize = TransformSize(ScreenWidth, ScreenHeight, Config_LocalUserImageSize, all)
		Transformded_OtherPlayerLineHight = TransformSize(ScreenWidth, ScreenHeight, Config_OtherPlayerLineHight, hight)
		Transformded_OtherPlayerImageSize = TransformSize(ScreenWidth, ScreenHeight, Config_OtherPlayerImageSize, all)

		local ArraySize = {
			TabWidth = Transformded_TabWidth,
			TabHight = Transformded_TabHight,
			LeftPanelWidth = Transformded_LeftPanelWidth,
			RightPanelWidth = Transformded_RightPanelWidth,
			LocalUserImageSize = Transformded_LocalUserImageSize,
			OtherPlayerLineHight = Transformded_OtherPlayerLineHight,
			OtherPlayerImageSize = Transformded_OtherPlayerImageSize
		}

		local MaxServerPlayers = game.MaxPlayers()
		local CurrentCountOfPlayers = #player.GetAll()

		local CurrentUserPing = LocalPlayer():Ping()
		local ServerTickrate = math.Round(1 / engine.TickInterval())
		local CurrentUserFPS = math.Round(1 /  FrameTime())

		local ServerName = GetConVar('hostname'):GetString()
		local CurrentUserNumber = LocalPlayer():UserID()
		local CurrentUserNick = LocalPlayer():Nick()

		--- TAB ---
		Tab = vgui.Create('DPanel')

		Tab:SetSize(ArraySize['TabWidth'], ArraySize['TabHight'])
		Tab:Center()
		Tab:MakePopup()
		Tab.Paint = function(TabPaint, TabWidth, TabHight)
			draw.RoundedBox(0, 0, 0, TabWidth, TabHight, PanelColor)
		end

		--- LEFT PANEL ---
		local LeftPanel = vgui.Create('DPanel', Tab)

		LeftPanel:SetSize(ArraySize['LeftPanelWidth'], ArraySize['TabHight'])
		LeftPanel:Dock(LEFT)
		LeftPanel.Paint = function(LeftPanelPaint, LeftPanelWidth, LeftPanelHight)
			local LeftPanelWidthCentre = math.Round(LeftPanelWidth * 0.5)
			draw.RoundedBoxEx(8, 0, 0, LeftPanelWidth, LeftPanelHight, LeftPanelColor, true, false, true, false)
			draw.SimpleText(ServerName, BigFontName, LeftPanelWidthCentre, math.Round(LeftPanelHight * 0.02), LightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText('Players: ' .. CurrentCountOfPlayers .. "ㅤ/ㅤ" .. MaxServerPlayers, SmallFontName, LeftPanelWidthCentre, math.Round(LeftPanelHight * 0.085), LightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText('Tickrate: ' .. ServerTickrate, SmallFontName, LeftPanelWidthCentre, math.Round(LeftPanelHight * 0.14), LightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(CurrentUserNick, SmallFontName, LeftPanelWidthCentre, math.Round(LeftPanelHight * 0.38), LightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText('Fps: ' .. CurrentUserFPS .. 'ㅤㅤㅤ' .. 'Ping: ' .. CurrentUserPing, SmallFontName, LeftPanelWidthCentre, math.Round(LeftPanelHight * 0.44), LightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local CurrentPlayerImage = vgui.Create('AvatarImage', LeftPanel)

		CurrentPlayerImage:SetSize(ArraySize['LocalUserImageSize'], ArraySize['LocalUserImageSize'])
		CurrentPlayerImage:SetPos(math.Round(math.Round(math.Round(ArraySize['LeftPanelWidth'] * 0.5) - (ArraySize['LocalUserImageSize'] * 0.5))), math.Round(ArraySize['TabHight'] * 0.2))
		CurrentPlayerImage:SetPlayer(LocalPlayer(), ArraySize['LocalUserImageSize'])

		--- RIGHT PANEL ---
		local RightPanel = vgui.Create('DPanel', Tab)

		RightPanel:SetSize(ArraySize['RightPanelWidth'], ArraySize['TabHight'])
		RightPanel:Dock(RIGHT)
		RightPanel.Paint = function(RightPanelPaint, RightPanelWidth, RightPanelHight)
			draw.RoundedBoxEx(8, 0, 0, RightPanelWidth, RightPanelHight, RightPanelColor, false, true, false, true)
		end

		local Scroll = vgui.Create('DScrollPanel', RightPanel)
		Scroll:Dock(FILL)
		Scroll:DockMargin(8, 8, 8, 8)
		Scroll:GetVBar():SetWide(0) -- Disabling scroller



		for k, pl in pairs(player.GetAll()) do

			if (CurrentUserNumber != pl:UserID()) then
				local PlayerLine = vgui.Create('DPanel', Scroll)

				PlayerLine:Dock(TOP)
				PlayerLine:DockMargin(0, 0, 0, 8)
				PlayerLine:SetTall(ArraySize['OtherPlayerLineHight'])
				PlayerLine.Paint = function(_, w, h)
					draw.RoundedBox(8, 0, 0, math.Round(ArraySize['RightPanelWidth'] - ArraySize['OtherPlayerLineHight'] * 0.25), ArraySize['OtherPlayerLineHight'], PlayerLineColor)
					draw.SimpleText(pl:Name(), SmallFontName, math.Round(ArraySize['RightPanelWidth'] * 0.1), math.Round(ArraySize['OtherPlayerLineHight'] * 0.5), LightTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText('Ping: ' .. pl:Ping(), SmallFontName, math.Round(ArraySize['RightPanelWidth'] * 0.2), math.Round(ArraySize['OtherPlayerLineHight'] * 0.5), LightTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					if (pl:SteamID() == 'BOT') then
						draw.SimpleText('BOT', SmallFontName, math.Round(ArraySize['RightPanelWidth'] * 0.5), math.Round(ArraySize['OtherPlayerLineHight'] * 0.5), LightTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
				end

				PlayerLine.OnMousePressed = function()
					PlayerContexMenu(LocalPlayer(), pl)
				end

				local PlayerImage = vgui.Create('AvatarImage', PlayerLine)

				PlayerImage:SetSize(ArraySize['OtherPlayerImageSize'], ArraySize['OtherPlayerImageSize'])
				PlayerImage:SetPos(math.Round(ArraySize['RightPanelWidth'] * 0.01), math.Round((ArraySize['OtherPlayerLineHight'] - ArraySize['OtherPlayerImageSize']) * 0.5))
				PlayerImage:SetPlayer(pl, ArraySize['OtherPlayerImageSize'])

				if (pl:SteamID() != 'BOT') then
					local MuteButton = vgui.Create('DButton', PlayerLine)

					MuteButton:SetText('')
					MuteButton:SetPos(math.Round((ArraySize['RightPanelWidth'] * 0.97) - ArraySize['OtherPlayerImageSize']), math.Round((ArraySize['OtherPlayerLineHight'] - ArraySize['OtherPlayerImageSize']) * 0.5))
					MuteButton:SetSize(ArraySize['OtherPlayerImageSize'], ArraySize['OtherPlayerImageSize'])
					MuteButton.TextColor = pl:IsMuted() and Color(255, 0, 0) or Color(255, 255, 255)
					MuteButton.Paint = function(MuteButtonPaint, MuteButtonWidth, MuteButtonHight)
						draw.RoundedBox(0, 0, 0, MuteButtonWidth, MuteButtonHight, Color(0, 0, 0, 0))
						local TextColor = pl:IsMuted() and Color(255, 0, 0) or Color(255, 255, 255)
						draw.SimpleText('M', SmallFontName, math.Round(MuteButtonWidth * 0.5), math.Round(MuteButtonHight * 0.5), MuteButton.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
					MuteButton.DoClick = function()
						pl:SetMuted(not pl:IsMuted())
						MuteButton.TextColor = pl:IsMuted() and Color(255, 0, 0) or Color(255, 255, 255)
					end
				end
			end
		end

		return false
	end)

	--- WHEN TAB IS CLOSE ---
	hook.Add('ScoreboardHide', 'TabIsClose', function()
		Tab:Remove()

		return false
	end)
end
