do local Fluent=loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))();local SaveManager=loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))();local InterfaceManager=loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))();local Window=Fluent:CreateWindow({Title="King Vongolay "   .. Fluent.Version ,SubTitle="",TabWidth=160,Size=UDim2.fromOffset(580,460),Acrylic=true,Theme="Dark",MinimizeKey=Enum.KeyCode.LeftControl});local Tabs={Main=Window:AddTab({Title="Main",Icon="box"}),Esp=Window:AddTab({Title="Esp",Icon="folder"}),Skill=Window:AddTab({Title="Skill",Icon="crown"}),Texture=Window:AddTab({Title="Texture",Icon="align-justify"}),iTem=Window:AddTab({Title="iTem",Icon="image"}),Settings=Window:AddTab({Title="Settings",Icon="settings"})};SaveManager:SetLibrary(Fluent);InterfaceManager:SetLibrary(Fluent);SaveManager:IgnoreThemeSettings();SaveManager:SetIgnoreIndexes({});InterfaceManager:SetFolder("FluentScriptHub");SaveManager:SetFolder("FluentScriptHub/specific-game");InterfaceManager:BuildInterfaceSection(Tabs.Settings);SaveManager:BuildConfigSection(Tabs.Settings);Window:SelectTab(1);Fluent:Notify({Title="King Vongolay",Content="The script has been loaded.",Duration=8});SaveManager:LoadAutoloadConfig();local isPreventingStaminaDrain=false;local connection;local function preventStaminaDrain() local player=game:GetService("Players").LocalPlayer;local staminaStat=player:FindFirstChild("PlayerStats");local stamina=staminaStat and staminaStat:FindFirstChild("Stamina") ;if  not stamina then return;end local minStamina=50;connection=game:GetService("RunService").Heartbeat:Connect(function() if (stamina and (stamina.Value<minStamina)) then stamina.Value=minStamina;end end);end local SettingsSection=Tabs.Main:AddSection("Legit Normal");local Toggle=Tabs.Main:AddToggle("SEMI INF STAMINA",{Title="! SEMI INF STAMINA",Default=false,Callback=function(Value) if Value then if  not isPreventingStaminaDrain then isPreventingStaminaDrain=true;task.spawn(preventStaminaDrain);end elseif isPreventingStaminaDrain then isPreventingStaminaDrain=false;if connection then connection:Disconnect();connection=nil;end end end});local autoDribbleEnabled=false;local function enableAutoDribble() autoDribbleEnabled=true;print("Auto Dribble Enabled");end local function disableAutoDribble() autoDribbleEnabled=false;print("Auto Dribble Disabled");end local Toggle=Tabs.Main:AddToggle("AutoDribble",{Title="Auto Dribble",Default=false});Toggle:OnChanged(function() if Toggle.Value then print("Auto Dribble is ON");enableAutoDribble();else print("Auto Dribble is OFF");disableAutoDribble();end end);local Players=game:GetService("Players");local VirtualInputManager=game:GetService("VirtualInputManager");local player=Players.LocalPlayer;local function getCharacter(player) return player.Character or player.CharacterAdded:Wait() ;end local character=getCharacter(player);local humanoidRootPart=character:WaitForChild("HumanoidRootPart");local slideRange=50;local kuniRange=80;local monitoredAnimations={["rbxassetid://18668814876"]=slideRange,["rbxassetid://124999361278741"]=kuniRange,["rbxassetid://112386511860884"]=kuniRange};local function pressQInstant() VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.Q,false,game);VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.Q,false,game);warn("⚡ [INSTANT] Auto กด Q พร้อมกับตรวจพบอนิเมชัน!");end local function trackPlayerAnimations(otherPlayer) if (otherPlayer~=player) then local function setupCharacter(character) local humanoid=character:FindFirstChildOfClass("Humanoid");if humanoid then local animator=humanoid:FindFirstChildOfClass("Animator");if animator then animator.AnimationPlayed:Connect(function(animationTrack) if autoDribbleEnabled then local animId=animationTrack.Animation.AnimationId;local detectRange=monitoredAnimations[animId];if detectRange then local otherHRP=character:FindFirstChild("HumanoidRootPart");if otherHRP then local distance=(humanoidRootPart.Position-otherHRP.Position).Magnitude;if (distance<=detectRange) then pressQInstant();end end end end end);end end end if otherPlayer.Character then setupCharacter(otherPlayer.Character);end otherPlayer.CharacterAdded:Connect(function(newCharacter) setupCharacter(newCharacter);end);end end local function trackAllPlayers() for _,otherPlayer in ipairs(Players:GetPlayers()) do trackPlayerAnimations(otherPlayer);end end Players.PlayerAdded:Connect(function(player) player.CharacterAdded:Connect(function(newCharacter) trackAllPlayers();end);end);trackAllPlayers();player.CharacterAdded:Connect(function(newCharacter) character=newCharacter;humanoidRootPart=newCharacter:WaitForChild("HumanoidRootPart");end);local Toggle=Tabs.Main:AddToggle("Jump",{Title="Header Two Stroke",Default=false});local player=game.Players.LocalPlayer;local humanoid=nil;local originalJumpPower=nil;local function onCharacterAdded(character) humanoid=character:WaitForChild("Humanoid");originalJumpPower=humanoid.JumpPower;if Toggle.Value then humanoid.JumpPower=50.3;humanoid.UseJumpPower=true;else humanoid.JumpPower=originalJumpPower;humanoid.UseJumpPower=true;end end player.CharacterAdded:Connect(onCharacterAdded);if player.Character then onCharacterAdded(player.Character);end Toggle:OnChanged(function() if humanoid then if Toggle.Value then humanoid.JumpPower=50.3;humanoid.UseJumpPower=true;elseif originalJumpPower then humanoid.JumpPower=originalJumpPower;humanoid.UseJumpPower=true;end end end);Toggle:SetValue(false);local SettingsSection=Tabs.Main:AddSection("Hitbox");local RunService=game:GetService("RunService");local Players=game:GetService("Players");local Toggle=Tabs.Main:AddToggle("enable_hitbox",{Title="Enable Hitbox",Default=false});local running=false;local hitboxSize=10;local hitboxConnection;local adornment=Instance.new("SphereHandleAdornment");local function FindFootball() local success,football=pcall(function() local fb=workspace:FindFirstChild("Football");if  not fb then for _,player in ipairs(Players:GetPlayers()) do if player.Character then fb=player.Character:FindFirstChild("Football");if fb then break;end end end end return fb;end);return (success and football) or nil ;end local function UpdateHitbox() local football=FindFootball();if football then local hitbox=football:FindFirstChild("Hitbox");if (hitbox and hitbox:IsA("BasePart")) then hitbox:SetAttribute("DefaultSize",hitbox:GetAttribute("DefaultSize") or hitbox.Size );hitbox.Size=Vector3.new(hitboxSize,hitboxSize,hitboxSize);end end end Toggle:OnChanged(function(value) running=value;if running then UpdateHitbox();hitboxConnection=RunService.RenderStepped:Connect(UpdateHitbox);else if hitboxConnection then hitboxConnection:Disconnect();hitboxConnection=nil;end local football=FindFootball();if football then local hitbox=football:FindFirstChild("Hitbox");if (hitbox and hitbox:IsA("BasePart")) then hitbox.Size=hitbox:GetAttribute("DefaultSize") or Vector3.new(2.5,2.5,2.5) ;end end adornment.Parent=nil;end end);local ShowHitboxToggle=Tabs.Main:AddToggle("ShowHitboxSize",{Title="Show hitbox size",Default=false});local function updateAdornment() local football=FindFootball();if football then local hitbox=football:FindFirstChild("Hitbox");if hitbox then adornment.Adornee=hitbox;adornment.Color3=Color3.new(1,1,1);adornment.Transparency=0.9;adornment.AlwaysOnTop=true;adornment.Parent=hitbox;adornment.Radius=math.max(hitbox.Size.X,hitbox.Size.Y,hitbox.Size.Z)/2 ;adornment.Visible=ShowHitboxToggle.Value;else adornment.Parent=nil;end else adornment.Parent=nil;end end ShowHitboxToggle:OnChanged(updateAdornment);RunService.RenderStepped:Connect(updateAdornment);local Input=Tabs.Main:AddInput("HitboxSize",{Title="Hitbox Size",Default="10",Placeholder="Enter size (3-30)",Numeric=true,Finished=true,Callback=function(Value) local size=tonumber(Value);if (size and (size>=3) and (size<=30)) then hitboxSize=size;if running then UpdateHitbox();end else print("Invalid size. Please enter a number between 3 and 30.");end end});local Keybind=Tabs.Main:AddKeybind("Keybind",{Title="KeyBind Hitbox",Mode="Toggle",Default="",Callback=function() Toggle:SetValue( not running);Fluent:Notify({Title="Hitbox Vongolay",Content=(running and "Hitbox Enabled") or "Hitbox Disabled" ,Duration=5});end,ChangedCallback=function(New) print("Keybind changed!",New);end});local SettingsSection=Tabs.Main:AddSection("Auto Join Team");local player=game:GetService("Players").LocalPlayer;local ReplicatedStorage=game:GetService("ReplicatedStorage");local autoJoinEnabled=false;local runningAutoJoin=false;local teamService=ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TeamService"):WaitForChild("RE"):WaitForChild("Select");local TeamDropdown=Tabs.Main:AddDropdown("TeamSelection",{Title="Select Team",Values={"Home","Away"},Multi=false,Default=1,Callback=function(Value) print("Selected Team: "   .. Value );end});local PositionDropdown=Tabs.Main:AddDropdown("PositionSelection",{Title="Select Position",Values={"CF","LW","RW","CM","GK"},Multi=false,Default=1,Callback=function(Value) print("Selected Position: "   .. Value );end});local function joinTeam() if  not autoJoinEnabled then return;end if runningAutoJoin then return;end runningAutoJoin=true;while autoJoinEnabled do local selectedTeam=TeamDropdown.Value or "Home" ;local selectedPosition=PositionDropdown.Value or "CF" ;if ((player.Team==nil) or (player.Team.Name=="Visitor")) then teamService:FireServer(selectedTeam,selectedPosition);print("กำลังเข้าร่วมทีม:",selectedTeam,"ตำแหน่ง:",selectedPosition);else print("คุณอยู่ในทีมแล้ว:",player.Team.Name);break;end task.wait(1);end runningAutoJoin=false;end local ToggleAutoJoin=Tabs.Main:AddToggle("AutoJoinToggle",{Title="Auto Join Team",Default=false,Callback=function(Value) autoJoinEnabled=Value;print("Auto Join Team:",(Value and "เปิด") or "ปิด" );if Value then task.spawn(joinTeam);end end});player:GetPropertyChangedSignal("Team"):Connect(function() if autoJoinEnabled then joinTeam();end end);local Keybind=Tabs.Main:AddKeybind("AutoJoinKeybind",{Title="Toggle Auto Join Team Keybind",Mode="Toggle",Default="",Callback=function(Value) ToggleAutoJoin:SetValue(Value);Fluent:Notify({Title="Auto Join Team",Content=(Value and "Enabled") or "Disabled" ,Duration=5});end,ChangedCallback=function(New) print("Keybind changed!",New);end});local SettingsSection=Tabs.Skill:AddSection("Skill");local attributeNames={"AirDash","BigBang","BodyBlock","CenterOfGravity","ChargeAiku","CrowClearance","Curved","CurveShot","Devour","DirectPass","DirectShot","DragonDrive","DragonHeader","Fadeaway","FallenHero","FinalShot","ForcePass","Freestyle","GagamaruHeader","GyroShot","Handstand","Header","HeelFlick","IAmNagi","InfiniteDribbles","Joker","KingsDribble","KingsImpact","Laser","LethalTouch","MagicalTurn","MonsterTrance","NinjaDribble","NinjaShot","Nutmeg","OPCurve","Opposite","PerfectPass","PowerShot","RavenDribble","Scissors","ScorpionKick","StealthySteps","StreetDribbling","Surpass","Tiredless","TotalDefense","AirDribble","shotStart","ScorpionKick","Scorpion","DivingHeader","GoldenDefense","ZombieDribble","ZombieDash","GoldenDefenseL","GoldenDefenseLHeader","GoldenDefenseR","GoldenDefenseRHeader","UndeadMode","YoMichael","ZombieCounterAttack","ForcePass","ChargeAiku","ForcedDefense","Charge","ChargeSteal","Steal","Nutmeg"};local AbilityCooldowns=game.ReplicatedStorage:WaitForChild("AbilityCooldowns");local Toggle=Tabs.Skill:AddToggle("SemiSkillNoCD",{Title="! SEMI SKILL NO CD",Default=false});local isToggled=false;Toggle:OnChanged(function(state) if (state~=isToggled) then isToggled=state;if state then for _,attributeName in ipairs(attributeNames) do AbilityCooldowns:SetAttribute(attributeName,0);end print("SEMI SKILL NO CD: ENABLED");else for _,attributeName in ipairs(attributeNames) do AbilityCooldowns:SetAttribute(attributeName,1);end print("SEMI SKILL NO CD: DISABLED");end end end);local Players=game:GetService("Players");local RunService=game:GetService("RunService");local localPlayer=Players.LocalPlayer;local espEnabled=false;local espObjects={};local textSize=14;local espHeightOffset=3;local function getPlayerStyle(player) local stats=player:FindFirstChild("PlayerStats");if stats then local style=stats:FindFirstChild("Style");if (style and style:IsA("StringValue")) then return style.Value;end end return "Unknown";end local function createESP(character,player) if ((player==localPlayer) or  not character) then return;end local head=character:FindFirstChild("Head");if  not head then return;end if espObjects[player] then espObjects[player].Billboard:Destroy();espObjects[player]=nil;end local billboardGui=Instance.new("BillboardGui");billboardGui.Size=UDim2.new(0,100,0,50);billboardGui.Adornee=head;billboardGui.StudsOffset=Vector3.new(0,espHeightOffset,0);billboardGui.AlwaysOnTop=true;billboardGui.Parent=head;local textLabel=Instance.new("TextLabel");textLabel.Size=UDim2.new(1,0,1,0);textLabel.BackgroundTransparency=1;textLabel.TextColor3=Color3.fromRGB(255,255,255);textLabel.Font=Enum.Font.SourceSansBold;textLabel.TextSize=textSize;textLabel.TextScaled=false;textLabel.Text=" "   .. getPlayerStyle(player)   .. " " ;textLabel.Parent=billboardGui;espObjects[player]={Billboard=billboardGui,TextLabel=textLabel};end local function updateTextSize() for _,obj in pairs(espObjects) do if obj.TextLabel then obj.TextLabel.TextSize=textSize;end end end local function enableESP() espEnabled=true;for _,player in pairs(Players:GetPlayers()) do if player.Character then createESP(player.Character,player);end end end local function disableESP() espEnabled=false;for _,obj in pairs(espObjects) do if obj.Billboard then obj.Billboard:Destroy();end end espObjects={};end Players.PlayerAdded:Connect(function(player) player.CharacterAdded:Connect(function(character) if espEnabled then task.defer(function() createESP(character,player);end);end end);end);Players.PlayerRemoving:Connect(function(player) if espObjects[player] then if espObjects[player].Billboard then espObjects[player].Billboard:Destroy();end espObjects[player]=nil;end end);task.spawn(function() while true do task.wait(1);if espEnabled then for _,player in pairs(Players:GetPlayers()) do if ((player~=localPlayer) and player.Character) then createESP(player.Character,player);end end end end end);local ToggleESP=Tabs.Esp:AddToggle("ESP_TOGGLE",{Title="Enable ESP",Default=false,Callback=function(Value) if Value then enableESP();else disableESP();end end});local Slider=Tabs.Esp:AddSlider("TextSize_Slider",{Title="Text Size",Description="Adjust ESP text size",Default=textSize,Min=10,Max=30,Rounding=0,Callback=function(Value) textSize=Value;updateTextSize();end});local SettingsSection=Tabs.iTem:AddSection("Cards");local Dropdown=Tabs.iTem:AddDropdown("Cards",{Title="Cards",Values={"Blue","Blue Sky","Crow","Crystal","Dragon","Earthquake","Forest","GLITCH","Galaxy","Golden","Golden Winter","Green","Holiday","Inside","Itoshi Rin","Itoshi Sae","LEGEND","Lava","Liga","Lunar","MONEY","New Years","Orange","Pattern","Pinky","Premiere","Rage","Red","STREET","Speciality","VIP","Valentines","Water","Wood","YingYang"},Multi=false,Default=1});Dropdown:SetValue("Blue");Dropdown:OnChanged(function(Value) print("Dropdown changed:",Value);end);Tabs.iTem:AddButton({Title="Enter Cards",Description="Select a card from the dropdown",Callback=function() local selectedValue=Dropdown.Value;if selectedValue then local args={[1]="Cards",[2]=selectedValue};game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CustomizationService"):WaitForChild("RE"):WaitForChild("Customize"):FireServer(unpack(args));else print("No card selected");end end});local SettingsSection=Tabs.iTem:AddSection("Goal Effects");local Dropdown=Tabs.iTem:AddDropdown("Goal Effects",{Title="Goal Effects",Values={"CITY","Cherry Blossom","Conquer","DRAGON","GLITCH","GRAVEYARD","Gingerbread","Grillz","Lantern","Lightning","Presents","StreetVfx","Time Stop","Vaporwave","Wonderland","Life Explosion","Blackhole","Card","Crow","Defender","Fire","Genius","Glass","Heart","Pixel","Rin","Sae","Sand","Snowflakes","Thunder","Valentines","Water Wild Goal"},Multi=false,Default=1});Dropdown:SetValue("CITY");Dropdown:OnChanged(function(Value) print("Dropdown changed:",Value);end);Tabs.iTem:AddButton({Title="Enter Goal Effects",Description="Select a goal effect from the dropdown",Callback=function() local selectedValue=Dropdown.Value;if selectedValue then local args={[1]="GoalEffects",[2]=selectedValue};game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CustomizationService"):WaitForChild("RE"):WaitForChild("Customize"):FireServer(unpack(args));else print("No goal effect selected");end end});local SettingsSection=Tabs.iTem:AddSection("Cosmetics");local Dropdown=Tabs.iTem:AddDropdown("Cosmetics",{Title="Cosmetics",Values={"Angel Wings","Shidou Wings","Cape","Dragon Cape","Dribblers Glasses","Gingerbread Cape","Golden Grills","Ninja","Peppermint Cape","Santa Hat","Santa Scarf","Shadow Cape","Snowman Cape","COSMIC","Christmas Aura","Fireworks","GLITCH","SHADOW","Valentines"},Multi=false,Default=1});Dropdown:SetValue("Angel Wings");Dropdown:OnChanged(function(Value) print("Dropdown changed:",Value);end);Tabs.iTem:AddButton({Title="Enter Cosmetics",Description="Select a cosmetic from the dropdown",Callback=function() local selectedValue=Dropdown.Value;if selectedValue then local args={[1]="Cosmetics",[2]=selectedValue};game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CustomizationService"):WaitForChild("RE"):WaitForChild("Customize"):FireServer(unpack(args));else print("No cosmetic selected");end end});local Toggle=Tabs.Texture:AddToggle("Grey",{Title="Grey",Default=false});local function changePartProperties(part,color,material) if part:IsA("BasePart") then part.Color=color;part.Material=material;end end Toggle:OnChanged(function() if Toggle.Value then print("Grey mode enabled");local field=workspace.Field.Field;changePartProperties(field,Color3.new(0.301961,0.301961,0.301961),Enum.Material.Snow);local carpet=workspace.NewLobby.NewFixed.Structural.Floor.Carpet.Carpet;if carpet:IsA("MeshPart") then carpet.Color=Color3.fromRGB(255,255,255);carpet.Material=Enum.Material.Snow;end local darkgrass=workspace.Field.darkgrass;changePartProperties(darkgrass,Color3.new(0,0,0),Enum.Material.Snow);for i=12,14 do local part=workspace.Field:GetChildren()[i];changePartProperties(part,Color3.new(0,0,0),Enum.Material.Snow);end for i=20,21 do local part=workspace.SoccerMap2:GetChildren()[i];changePartProperties(part,Color3.new(0.360784,0.360784,0.360784),Enum.Material.Snow);end else print("Grey mode disabled");end end); end
