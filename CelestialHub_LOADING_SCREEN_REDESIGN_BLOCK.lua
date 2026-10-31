-- Pantalla de carga rediseñada. La detección, su orden de ejecución y sus límites
-- originales (mínimo 5 s / máximo 7 s) permanecen fuera de este bloque.
do
	local FRAME_IMAGE_ID = "rbxassetid://129894504510080"
	local LOADING_MOON_IMAGE_ID = DYNAMIC_ISLAND_CONFIG.BubbleImageId
	local LOADING_CONFIG = {
		FrameSize = Vector2.new(380, 190),
		FrameScale = Vector2.new(1.2069, 1.4762),
		FrameImageVisibleRect = {X = 0.0857, Y = 0.1613, W = 0.8286, H = 0.6774},
		DesignSize = Vector2.new(580, 252),
		ProgressDuration = 7,
		Title = "Loading Celestial Hub...",
		TitleFontSize = 25,
		StarFontSize = 24,
		StarSpacing = 10,
		States = {
			{At = 0, Text = "Initializing"},
			{At = 25, Text = "Loading modules"},
			{At = 55, Text = "Preparing interface"},
			{At = 85, Text = "Almost ready"},
			{At = 100, Text = "Ready"},
		},
		Colors = {
			White = Color3.fromRGB(255, 255, 255),
			Silver = Color3.fromRGB(211, 213, 223),
			Lilac = Color3.fromRGB(185, 166, 255),
			MoonBlue = Color3.fromRGB(127, 180, 255),
			MoonDark = Color3.fromRGB(42, 42, 58),
			CardDark = Color3.fromRGB(8, 7, 15),
			StarOff = Color3.fromRGB(44, 40, 80),
			StarOn = Color3.fromRGB(230, 220, 255),
			Status = Color3.fromRGB(143, 140, 171),
		},
	}

	local function rememberTween(state, tween)
		table.insert(state.Tweens, tween)
		return tween
	end

	local function playTween(state, object, info, properties)
		local tween = rememberTween(state, TweenService:Create(object, info, properties))
		tween:Play()
		return tween
	end

	local animateEclipse

	local function setProgress(state, progress)
		if not state.Running or not state.Gui.Parent then return end
		local p = math.clamp(tonumber(progress) or 0, 0, 1)
		local pct = math.floor(p * 100 + 0.5)
		state.Fill.Size = UDim2.new(p, 0, 1, 0)
		state.Percent.Text = "★ " .. tostring(pct) .. "%"
		state.Moon.ImageColor3 = LOADING_CONFIG.Colors.MoonDark:Lerp(LOADING_CONFIG.Colors.White, p)
		state.MoonGlow.BackgroundTransparency = 0.82 - (0.34 * p)
		state.MoonHaloStroke.Transparency = 0.48 - (0.35 * p)
		animateEclipse(state, p)

		local stage = LOADING_CONFIG.States[1].Text
		for i = #LOADING_CONFIG.States, 1, -1 do
			if pct >= LOADING_CONFIG.States[i].At then
				stage = LOADING_CONFIG.States[i].Text
				break
			end
		end
		state.Status.Text = stage

		for i, threshold in ipairs({0.2, 0.4, 0.6, 0.8, 1}) do
			if p >= threshold and not state.StarLit[i] then
				state.StarLit[i] = true
				local star = state.Stars[i]
				star.TextColor3 = LOADING_CONFIG.Colors.StarOn
				local stroke = star:FindFirstChildOfClass("UIStroke")
				if stroke then stroke.Transparency = 0.5 end
				local scale = star:FindFirstChildOfClass("UIScale")
				if scale then
					playTween(state, scale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.12})
				end
			end
		end
	end

	animateEclipse = function(state, progress)
		local p = math.clamp(progress, 0, 1)
		state.Eclipse.Position = UDim2.new(p * 0.92, 0, 0, 0)
		state.Eclipse.ImageTransparency = p
	end

	local function animateTitleGradient(state)
		local gradientInfo = TweenInfo.new(2.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
		state.TitleGradient.Offset = Vector2.new(-1, 0)
		state.PercentGradient.Offset = Vector2.new(-1, 0)
		playTween(state, state.TitleGradient, gradientInfo, {Offset = Vector2.new(1, 0)})
		playTween(state, state.PercentGradient, gradientInfo, {Offset = Vector2.new(1, 0)})
	end

	local pendingLoadingGui
	local function createLoadingWindow()
		local gui = Instance.new("ScreenGui")
		gui.Name = "CelestialScanGui"
		gui.ResetOnSpawn = false
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 1000000
		gui.Parent = CoreGui
		pendingLoadingGui = gui

		local state = {
			Gui = gui,
			Tweens = {},
			Connections = {},
			Threads = {},
			Running = true,
			StarLit = {},
			Stars = {},
		}

		state.DestroyConnection = gui.Destroying:Connect(function()
			state.Running = false
			for _, tween in ipairs(state.Tweens) do pcall(function() tween:Cancel() end) end
			for _, thread in ipairs(state.Threads) do pcall(task.cancel, thread) end
			for _, connection in ipairs(state.Connections) do pcall(function() connection:Disconnect() end) end
		end)

		local group = Instance.new("CanvasGroup")
		group.Name = "LoadingGroup"
		group.AnchorPoint = Vector2.new(0.5, 0.5)
		group.Size = UDim2.fromOffset(LOADING_CONFIG.FrameSize.X, LOADING_CONFIG.FrameSize.Y)
		group.Position = UDim2.new(0.5, 0, 0.5, 14)
		group.BackgroundTransparency = 1
		group.GroupTransparency = 1
		group.Parent = gui
		state.Group = group

		local responsiveScale = Instance.new("UIScale")
		responsiveScale.Name = "ResponsiveScale"
		responsiveScale.Parent = group
		local function updateScale()
			local camera = Workspace.CurrentCamera
			local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
			responsiveScale.Scale = math.clamp(math.min(viewport.X / 410, viewport.Y / 225), 0.58, 1)
		end
		updateScale()
		if Workspace.CurrentCamera then
			table.insert(state.Connections, Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
		end

		-- La imagen completa incluye margen transparente. Su zona visible coincide
		-- exactamente con los 380 x 190 px del antiguo recuadro.
		local frameImage = Instance.new("ImageLabel")
		frameImage.Name = "LoadingFrameTexture"
		frameImage.AnchorPoint = Vector2.new(0.5, 0.5)
		frameImage.Position = UDim2.fromScale(0.5, 0.5)
		frameImage.Size = UDim2.fromOffset(
			LOADING_CONFIG.FrameSize.X * LOADING_CONFIG.FrameScale.X,
			LOADING_CONFIG.FrameSize.Y * LOADING_CONFIG.FrameScale.Y
		)
		frameImage.BackgroundTransparency = 1
		frameImage.Image = FRAME_IMAGE_ID
		frameImage.ScaleType = Enum.ScaleType.Stretch
		frameImage.ZIndex = 1
		frameImage.Parent = group

		local content = Instance.new("Frame")
		content.Name = "Contenido"
		content.Position = UDim2.fromScale(
			LOADING_CONFIG.FrameImageVisibleRect.X,
			LOADING_CONFIG.FrameImageVisibleRect.Y
		)
		content.Size = UDim2.fromScale(
			LOADING_CONFIG.FrameImageVisibleRect.W,
			LOADING_CONFIG.FrameImageVisibleRect.H
		)
		content.BackgroundTransparency = 1
		content.BorderSizePixel = 0
		content.ClipsDescendants = true
		content.ZIndex = 2
		content.Parent = frameImage
		state.Content = content

		local designScale = Instance.new("UIScale")
		designScale.Name = "DesignScale"
		designScale.Parent = content
		local function updateDesignScale()
			local size = content.AbsoluteSize
			designScale.Scale = math.max(0.35, math.min(size.X / LOADING_CONFIG.DesignSize.X, size.Y / LOADING_CONFIG.DesignSize.Y))
		end
		updateDesignScale()
		table.insert(state.Connections, content:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateDesignScale))

		-- Decoración ambiental: estrellas pequeñas parpadeantes.
		local decorStars = {
			{X = 0.48, Y = 0.12, Delay = 0.00},
			{X = 0.92, Y = 0.18, Delay = 0.37},
			{X = 0.60, Y = 0.86, Delay = 0.74},
			{X = 0.06, Y = 0.84, Delay = 1.11},
			{X = 0.96, Y = 0.70, Delay = 1.48},
		}
		for i, data in ipairs(decorStars) do
			local twinkle = Instance.new("TextLabel")
			twinkle.Name = "DecorStar" .. i
			twinkle.AnchorPoint = Vector2.new(0.5, 0.5)
			twinkle.Position = UDim2.fromScale(data.X, data.Y)
			twinkle.Size = UDim2.fromOffset(14, 14)
			twinkle.BackgroundTransparency = 1
			twinkle.Text = "★"
			twinkle.TextColor3 = LOADING_CONFIG.Colors.Lilac
			twinkle.TextSize = 10
			twinkle.Font = Enum.Font.GothamBold
			twinkle.TextTransparency = 0.8
			twinkle.ZIndex = 3
			twinkle.Parent = content
			table.insert(state.Threads, task.spawn(function()
				task.wait(data.Delay)
				if not state.Running or not twinkle.Parent then return end
				playTween(state, twinkle, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 0.1})
			end))
		end

		-- Dos estrellas fugaces recorren diagonales contenidas en la tarjeta.
		local function makeShootingStar(index, delayTime)
			local streak = Instance.new("Frame")
			streak.Name = "ShootingStar" .. index
			streak.AnchorPoint = Vector2.new(0.5, 0.5)
			streak.Position = UDim2.fromScale(0.12, 0.12)
			streak.Size = UDim2.fromOffset(90, 2)
			streak.Rotation = 24
			streak.BackgroundColor3 = LOADING_CONFIG.Colors.White
			streak.BackgroundTransparency = 1
			streak.BorderSizePixel = 0
			streak.ZIndex = 4
			streak.Parent = content
			Instance.new("UICorner", streak).CornerRadius = UDim.new(1, 0)
			local streakGradient = Instance.new("UIGradient", streak)
			streakGradient.Color = ColorSequence.new(LOADING_CONFIG.Colors.White, LOADING_CONFIG.Colors.MoonBlue)
			streakGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.35, 0.12),
				NumberSequenceKeypoint.new(1, 1),
			})
			table.insert(state.Threads, task.spawn(function()
				task.wait(delayTime)
				while state.Running and gui.Parent do
					streak.Position = UDim2.fromScale(0.12, 0.12)
					streak.BackgroundTransparency = 0.05
					local travel = playTween(state, streak, TweenInfo.new(1.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
						Position = UDim2.fromScale(0.76, 0.76),
						BackgroundTransparency = 1,
					})
					travel.Completed:Wait()
					task.wait(3.1)
				end
			end))
		end
		makeShootingStar(1, 0)
		makeShootingStar(2, 2.1)

		-- Luna, halo y resplandor.
		local moonDiameter = LOADING_CONFIG.DesignSize.Y * 0.63
		local moonX = LOADING_CONFIG.DesignSize.X * 0.08
		local moonY = (LOADING_CONFIG.DesignSize.Y - moonDiameter) * 0.5
		local moonGlow = Instance.new("Frame")
		moonGlow.Name = "MoonSoftGlow"
		moonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
		moonGlow.Position = UDim2.fromOffset(moonX + moonDiameter / 2, moonY + moonDiameter / 2)
		moonGlow.Size = UDim2.fromOffset(moonDiameter + 42, moonDiameter + 42)
		moonGlow.BackgroundColor3 = LOADING_CONFIG.Colors.Lilac
		moonGlow.BackgroundTransparency = 0.82
		moonGlow.BorderSizePixel = 0
		moonGlow.ZIndex = 4
		moonGlow.Parent = content
		Instance.new("UICorner", moonGlow).CornerRadius = UDim.new(1, 0)
		local moonGlowGradient = Instance.new("UIGradient", moonGlow)
		moonGlowGradient.Color = ColorSequence.new(LOADING_CONFIG.Colors.Lilac, LOADING_CONFIG.Colors.MoonBlue)

		local halo = Instance.new("Frame")
		halo.Name = "MoonHalo"
		halo.AnchorPoint = Vector2.new(0.5, 0.5)
		halo.Position = UDim2.fromOffset(moonX + moonDiameter / 2, moonY + moonDiameter / 2)
		halo.Size = UDim2.fromOffset(moonDiameter + 24, moonDiameter + 24)
		halo.BackgroundTransparency = 1
		halo.ZIndex = 5
		halo.Parent = content
		Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)
		local haloStroke = Instance.new("UIStroke", halo)
		haloStroke.Thickness = 1.5
		haloStroke.Transparency = 0.48
		local haloGradient = Instance.new("UIGradient", haloStroke)
		haloGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, LOADING_CONFIG.Colors.White),
			ColorSequenceKeypoint.new(0.33, LOADING_CONFIG.Colors.Lilac),
			ColorSequenceKeypoint.new(0.68, LOADING_CONFIG.Colors.MoonBlue),
			ColorSequenceKeypoint.new(1, LOADING_CONFIG.Colors.White),
		})

		local moon = Instance.new("ImageLabel")
		moon.Name = "LoadingMoon"
		moon.Position = UDim2.fromOffset(moonX, moonY)
		moon.Size = UDim2.fromOffset(moonDiameter, moonDiameter)
		moon.BackgroundTransparency = 1
		moon.Image = LOADING_MOON_IMAGE_ID
		moon.ImageColor3 = LOADING_CONFIG.Colors.MoonDark
		moon.ScaleType = Enum.ScaleType.Crop
		moon.ZIndex = 6
		moon.Parent = content
		Instance.new("UICorner", moon).CornerRadius = UDim.new(1, 0)

		local eclipse = Instance.new("ImageLabel")
		eclipse.Name = "MoonEclipse"
		eclipse.Position = UDim2.fromOffset(moonX, moonY)
		eclipse.Size = UDim2.fromOffset(moonDiameter, moonDiameter)
		eclipse.BackgroundTransparency = 1
		eclipse.Image = LOADING_MOON_IMAGE_ID
		eclipse.ImageColor3 = LOADING_CONFIG.Colors.CardDark
		eclipse.ImageTransparency = 0
		eclipse.ScaleType = Enum.ScaleType.Crop
		eclipse.ZIndex = 7
		eclipse.Parent = content
		Instance.new("UICorner", eclipse).CornerRadius = UDim.new(1, 0)

		state.Moon = moon
		state.MoonGlow = moonGlow
		state.MoonHaloStroke = haloStroke
		state.Eclipse = eclipse

		-- Información a la derecha.
		local infoX = LOADING_CONFIG.DesignSize.X * 0.408
		local infoWidth = LOADING_CONFIG.DesignSize.X * 0.512
		local title = Instance.new("TextLabel")
		title.Name = "LoadingTitle"
		title.Position = UDim2.fromOffset(infoX, 43)
		title.Size = UDim2.fromOffset(infoWidth, 43)
		title.BackgroundTransparency = 1
		title.Text = LOADING_CONFIG.Title
		title.TextColor3 = LOADING_CONFIG.Colors.White
		title.Font = Enum.Font.GothamBold
		title.TextSize = LOADING_CONFIG.TitleFontSize
		title.TextWrapped = true
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextYAlignment = Enum.TextYAlignment.Center
		title.ZIndex = 8
		title.Parent = content
		local titleGradient = Instance.new("UIGradient", title)
		titleGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, LOADING_CONFIG.Colors.White),
			ColorSequenceKeypoint.new(0.36, LOADING_CONFIG.Colors.Silver),
			ColorSequenceKeypoint.new(0.68, LOADING_CONFIG.Colors.Lilac),
			ColorSequenceKeypoint.new(1, LOADING_CONFIG.Colors.White),
		})
		state.Title = title
		state.TitleGradient = titleGradient
		table.insert(state.Threads, task.spawn(function()
			local dots = {".", "..", "..."}
			local dotIndex = 1
			while state.Running and gui.Parent do
				title.Text = "Loading Celestial Hub" .. dots[dotIndex]
				dotIndex = dotIndex % #dots + 1
				task.wait(0.35)
			end
		end))

		local starsRow = Instance.new("Frame")
		starsRow.Name = "ProgressStars"
		starsRow.Position = UDim2.fromOffset(infoX, 99)
		starsRow.Size = UDim2.fromOffset(5 * 24 + 4 * 10, 34)
		starsRow.BackgroundTransparency = 1
		starsRow.ZIndex = 8
		starsRow.Parent = content
		for i = 1, 5 do
			local star = Instance.new("TextLabel")
			star.Name = "ProgressStar" .. i
			star.Position = UDim2.fromOffset((i - 1) * 34, 0)
			star.Size = UDim2.fromOffset(24, 30)
			star.BackgroundTransparency = 1
			star.Text = "★"
			star.TextColor3 = LOADING_CONFIG.Colors.StarOff
			star.TextSize = LOADING_CONFIG.StarFontSize
			star.Font = Enum.Font.GothamBold
			star.ZIndex = 9
			star.Parent = starsRow
			local stroke = Instance.new("UIStroke", star)
			stroke.Color = LOADING_CONFIG.Colors.Lilac
			stroke.Transparency = 1
			stroke.Thickness = 1
			local starScale = Instance.new("UIScale", star)
			state.Stars[i] = star
		end

		local track = Instance.new("Frame")
		track.Name = "ProgressTrack"
		track.Position = UDim2.fromOffset(infoX, 158)
		track.Size = UDim2.fromOffset(infoWidth, 3)
		track.BackgroundColor3 = LOADING_CONFIG.Colors.Lilac
		track.BackgroundTransparency = 0.82
		track.BorderSizePixel = 0
		track.ClipsDescendants = true
		track.ZIndex = 8
		track.Parent = content
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		local trackGlow = Instance.new("UIStroke", track)
		trackGlow.Color = LOADING_CONFIG.Colors.Lilac
		trackGlow.Transparency = 0.65
		trackGlow.Thickness = 1
		local fill = Instance.new("Frame")
		fill.Name = "ProgressFill"
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = LOADING_CONFIG.Colors.MoonBlue
		fill.BorderSizePixel = 0
		fill.ZIndex = 9
		fill.Parent = track
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
		local fillGradient = Instance.new("UIGradient", fill)
		fillGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, LOADING_CONFIG.Colors.MoonBlue),
			ColorSequenceKeypoint.new(0.5, LOADING_CONFIG.Colors.Lilac),
			ColorSequenceKeypoint.new(1, LOADING_CONFIG.Colors.White),
		})

		local status = Instance.new("TextLabel")
		status.Name = "LoadingStatus"
		status.Position = UDim2.fromOffset(infoX, 181)
		status.Size = UDim2.fromOffset(infoWidth - 95, 25)
		status.BackgroundTransparency = 1
		status.Text = LOADING_CONFIG.States[1].Text
		status.TextColor3 = LOADING_CONFIG.Colors.Status
		status.Font = Enum.Font.GothamMedium
		status.TextSize = 12
		status.TextXAlignment = Enum.TextXAlignment.Left
		status.ZIndex = 8
		status.Parent = content

		local percent = Instance.new("TextLabel")
		percent.Name = "ProgressPercent"
		percent.Position = UDim2.fromOffset(infoX + infoWidth - 100, 179)
		percent.Size = UDim2.fromOffset(100, 27)
		percent.BackgroundTransparency = 1
		percent.Text = "★ 0%"
		percent.TextColor3 = LOADING_CONFIG.Colors.White
		percent.Font = Enum.Font.GothamBold
		percent.TextSize = 15
		percent.TextXAlignment = Enum.TextXAlignment.Right
		percent.ZIndex = 8
		percent.Parent = content
		local percentGradient = Instance.new("UIGradient", percent)
		percentGradient.Color = titleGradient.Color
		state.Status = status
		state.Fill = fill
		state.Percent = percent
		state.PercentGradient = percentGradient

		animateTitleGradient(state)
		animateEclipse(state, 0)

		-- Entrada: fade-in, subida de 14 px y escala 0.96 -> 1 en 0.7 s.
		local groupScale = Instance.new("UIScale")
		groupScale.Name = "EntranceScale"
		groupScale.Scale = 0.96
		groupScale.Parent = group
		playTween(state, group, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			GroupTransparency = 0,
			Position = UDim2.new(0.5, 0, 0.5, 0),
		})
		playTween(state, groupScale, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1})

		return state
	end

	local function runLoading(state, duration)
		local loadDuration = math.max(0.1, tonumber(duration) or LOADING_CONFIG.ProgressDuration)
		local startedAt = tick()
		table.insert(state.Threads, task.spawn(function()
			while state.Running and state.Gui.Parent do
				local elapsed = tick() - startedAt
				local raw = math.clamp(elapsed / loadDuration, 0, 1)
				-- La barra conserva el 95 % hasta que la construcción original del Hub finaliza.
				local eased = raw < 0.5 and (2 * raw * raw) or (1 - ((-2 * raw + 2) ^ 2) / 2)
				setProgress(state, math.min(eased * 0.95, 0.95))
				if raw >= 1 then break end
				task.wait(0.04)
			end
		end))
	end

	local function closeLoadingWindow(state)
		if not state or not state.Gui or not state.Gui.Parent then return end
		setProgress(state, 1)
		state.Running = false
		state.Status.Text = "Ready"
		state.Fill.Size = UDim2.new(1, 0, 1, 0)
		state.Percent.Text = "★ 100%"
		task.wait(0.08)
		local fade = TweenService:Create(state.Group, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			GroupTransparency = 1,
		})
		table.insert(state.Tweens, fade)
		fade:Play()
		fade.Completed:Wait()
		state.Running = false
		for _, tween in ipairs(state.Tweens) do
			pcall(function() tween:Cancel() end)
		end
		for _, thread in ipairs(state.Threads) do
			pcall(task.cancel, thread)
		end
		for _, connection in ipairs(state.Connections) do
			pcall(function() connection:Disconnect() end)
		end
		if state.DestroyConnection then pcall(function() state.DestroyConnection:Disconnect() end) end
		if state.Gui and state.Gui.Parent then state.Gui:Destroy() end
		if _G.Celestial.ScanGui == state.Gui then _G.Celestial.ScanGui = nil end
	end

	_G.Celestial.ShowScanningGui = function()
		local ok, stateOrError = pcall(createLoadingWindow)
		if not ok or not stateOrError then
			pcall(function() if pendingLoadingGui and pendingLoadingGui.Parent then pendingLoadingGui:Destroy() end end)
			pendingLoadingGui = nil
			warn("[Celestial] No se pudo crear la ventana de carga; CH continuará con su arranque normal:", stateOrError)
			return nil
		end
		pendingLoadingGui = nil
		local state = stateOrError
		_G.Celestial.LoadingWindowState = state
		_G.Celestial.ScanGui = state.Gui
		runLoading(state, LOADING_CONFIG.ProgressDuration)
		_G.Celestial.CloseScanningGui = function()
			local closeOK, closeError = pcall(closeLoadingWindow, state)
			if not closeOK then
				warn("[Celestial] Error al cerrar la ventana de carga:", closeError)
				pcall(function()
					state.Running = false
					for _, tween in ipairs(state.Tweens) do tween:Cancel() end
					for _, thread in ipairs(state.Threads) do task.cancel(thread) end
					for _, connection in ipairs(state.Connections) do connection:Disconnect() end
					if state.Gui and state.Gui.Parent then state.Gui:Destroy() end
				end)
			end
		end
		return state.Gui
	end
end

