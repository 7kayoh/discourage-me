-- The main source code for discourage me! A plugin made by va1kio... for literally no reasons.
local Players = game:GetService("Players")

local Modules = script.Parent.Modules
local Phases = require(Modules.Phases)
local Tween = require(Modules.Tween)

local WIDGET_INFO = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Right,
	true,
	false,
	200,
	300,
	200,
	300
)

local UI = script.Parent.UI
local toolbar = plugin:CreateToolbar("Discourage me!")
local triggerButton = toolbar:CreateButton("Toggle window", "Toggles the plugin window", "")
local widget = plugin:CreateDockWidgetPluginGui("DiscourageMe", WIDGET_INFO)
local widgetUI = UI.View:Clone()


-- Functions
local function reactToApplicationTheme()
	if settings().Studio.Theme.Name == "Light" then
		widgetUI.Background.ImageColor3 = Color3.fromRGB(255, 255, 255)
		widgetUI.Gradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		UI.Dialog.Container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		UI.Dialog.Container.Tail.BackgroundColor3 = UI.Dialog.Container.BackgroundColor3
		UI.Dialog.Container.Title.TextColor3 = Color3.fromRGB(200, 200, 200)
	else
		widgetUI.Background.ImageColor3 = Color3.fromRGB(70, 70, 70)
		widgetUI.Gradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		UI.Dialog.Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UI.Dialog.Container.Tail.BackgroundColor3 = UI.Dialog.Container.BackgroundColor3
		UI.Dialog.Container.Title.TextColor3 = Color3.fromRGB(60, 60, 60)
	end
	
	if widgetUI.Bubbles:FindFirstChild("Dialog") then
		widgetUI.Bubbles.Dialog.Container.BackgroundColor3 = UI.Dialog.Container.BackgroundColor3
		widgetUI.Bubbles.Dialog.Container.Tail.BackgroundColor3 = UI.Dialog.Container.Tail.BackgroundColor3
		widgetUI.Bubbles.Dialog.Container.Title.TextColor3 = UI.Dialog.Container.Title.TextColor3
	end
end

local function createCharacter()
	local character
	if widgetUI.Viewport:FindFirstChildOfClass("Model") then
		widgetUI.Viewport:FindFirstChildOfClass("Model"):Destroy()
	end
	
	character = Players:CreateHumanoidModelFromUserId(plugin:GetStudioUserId())
	character.Parent = workspace
	wait(1.2)
	character.Parent = widgetUI.Viewport
	
	widgetUI.Viewport.CurrentCamera = widgetUI.Viewport.Camera
	widgetUI.Viewport.Camera.CFrame = character.PrimaryPart.CFrame * CFrame.new(0, 2, -5.5) * CFrame.Angles(0, math.rad(180), 0)
end

local function pickRandomPhase()
	local dialog = UI.Dialog:Clone()
	local selectedPhase = Phases[math.random(1, #Phases)]
	
	if widgetUI.Bubbles:FindFirstChild("Dialog") then
		while selectedPhase == widgetUI.Bubbles.Dialog.Container.Title.Text do
			selectedPhase = Phases[math.random(1, #Phases)]
		end
		
		widgetUI.Bubbles.Dialog:Destroy()
	end
	
	dialog.Parent = widgetUI.Bubbles
	dialog.Visible = false
	dialog.Container.Title.Text = selectedPhase
	dialog.Size = UDim2.new(0, math.ceil(dialog.Container.Title.TextBounds.X) + 18, 0, dialog.Container.Title.TextBounds.Y + 19)
	dialog.Container.UIScale.Scale = 0
	Tween(dialog.Container.UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Scale = 1})
	dialog.Visible = true
end


-- Events
widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if widgetUI.Bubbles:FindFirstChild("Dialog") then
		local cloneDialog = widgetUI.Bubbles.Dialog:Clone()
		cloneDialog.Name = ""
		cloneDialog.Size = UDim2.new(1, -24, 0, 10000)
		cloneDialog.Visible = false
		cloneDialog.Parent = widgetUI.Bubbles
		widgetUI.Bubbles.Dialog.Size = UDim2.new(0, math.ceil(cloneDialog.Container.Title.TextBounds.X) + 18, 0, cloneDialog.Container.Title.TextBounds.Y + 19)
		cloneDialog:Destroy()
	end
end)

widgetUI.Button.Trigger.MouseEnter:Connect(function()
	widgetUI.Button.Hover.BackgroundColor3 = Color3.new(1, 1, 1)
	widgetUI.Button.Hover.BackgroundTransparency = 0.85
end)

widgetUI.Button.Trigger.MouseButton1Up:Connect(pickRandomPhase)

widgetUI.Button.Trigger.MouseButton1Down:Connect(function()
	widgetUI.Button.Hover.BackgroundColor3 = Color3.new(0, 0, 0)
	widgetUI.Button.Hover.BackgroundTransparency = 0.85
end)

widgetUI.Button.Trigger.MouseLeave:Connect(function()
	widgetUI.Button.Hover.BackgroundTransparency = 1
end)

triggerButton.Click:Connect(function()
	triggerButton:SetActive(not widget.Enabled)
	widget.Enabled = not widget.Enabled
end)

triggerButton.ClickableWhenViewportHidden = true
widget.Title = "Discourage me!"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
widgetUI.Parent = widget

settings().Studio.ThemeChanged:Connect(reactToApplicationTheme)
reactToApplicationTheme()
createCharacter()
pickRandomPhase()