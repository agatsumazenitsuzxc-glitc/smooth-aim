local P=game:GetService('Players')
local R=game:GetService('RunService')
local U=game:GetService('UserInputService')
local Tween=game:GetService('TweenService')
local me=P.LocalPlayer
local pg=me:WaitForChild('PlayerGui')
local old=pg:FindFirstChild('AimSettings')
if old then old:Destroy() end
local cfg={enabled=false,speed=6,radius=1500,teams=true,walls=false,autofire=false,esp=false,interval=0.15,key=Enum.UserInputType.MouseButton2,toggleMode=false,showRadius=false,sticky=true,maxDistance=3000,debug=false,espLabels=false,hud=false,espColor=1}
local g=Instance.new('ScreenGui',pg)
g.Name='AimSettings'; g.ResetOnSpawn=false; g.IgnoreGuiInset=true
local palette={Color3.fromRGB(255,95,125),Color3.fromRGB(90,220,240),Color3.fromRGB(185,130,255),Color3.fromRGB(160,240,110)}
local links={}
local function on(signal,fn) table.insert(links,signal:Connect(fn)) end
local function new(class,props,parent)
 local o=Instance.new(class)
 for k,v in pairs(props) do o[k]=v end
 o.Parent=parent
 return o
end
local function corner(o,n) new('UICorner',{CornerRadius=UDim.new(0,n or 8)},o) end
local f=new('Frame',{Size=UDim2.fromOffset(360,604),Position=UDim2.new(.5,-180,.5,-302),BackgroundColor3=Color3.fromRGB(18,22,34),BorderSizePixel=0},g)
corner(f,16)
new('UIStroke',{Color=Color3.fromRGB(77,95,133),Transparency=0.35,Thickness=1},f)
new('UIGradient',{Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(155,173,215)),Rotation=100},f)
local accent=new('Frame',{Position=UDim2.fromOffset(20,69),Size=UDim2.fromOffset(320,2),BackgroundColor3=Color3.fromRGB(99,210,224),BorderSizePixel=0},f)
new('UIGradient',{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})},accent)
local scale=new('UIScale',{Scale=1},f)
local function fitMenu()
 local camera=workspace.CurrentCamera
 if camera then scale.Scale=math.clamp((camera.ViewportSize.Y-40)/604,0.5,1) end
end
fitMenu()
on(workspace:GetPropertyChangedSignal('CurrentCamera'),fitMenu)
local controlParent=f
local refreshers={}
local function text(s,y,size)
 return new('TextLabel',{Text=s,Position=UDim2.fromOffset(20,y-(controlParent==f and 0 or 82)),Size=UDim2.fromOffset(320,28),BackgroundTransparency=1,TextColor3=Color3.fromRGB(225,231,250),TextSize=size or 14,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},controlParent)
end
local title=text('SMOOTH / AIM',14,22)
title.Font=Enum.Font.GothamBold
title.TextColor3=Color3.fromRGB(151,229,238)
local subtitle=text('RightShift: menu    /    End: disable all',44,10)
subtitle.TextColor3=Color3.fromRGB(139,155,185)
title.Size=UDim2.fromOffset(260,28)
local restore=new('TextButton',{
 Text='AIM',Size=UDim2.fromOffset(58,40),Position=UDim2.fromOffset(16,160),
 BackgroundColor3=Color3.fromRGB(74,82,165),BorderSizePixel=0,
 TextColor3=Color3.fromRGB(233,238,255),TextSize=14,Font=Enum.Font.GothamBold,
 Visible=false,
},g)
corner(restore,12)
local minimize=new('TextButton',{
 Text='—',Size=UDim2.fromOffset(36,28),Position=UDim2.new(1,-52,0,14),
 BackgroundColor3=Color3.fromRGB(37,44,65),BorderSizePixel=0,
 TextColor3=Color3.fromRGB(233,238,255),TextSize=18,Font=Enum.Font.GothamBold,
},f)
corner(minimize,8)
local function setMenuVisible(visible)
 f.Visible=visible
 restore.Visible=not visible
end
on(minimize.Activated,function() setMenuVisible(false) end)
on(restore.Activated,function() setMenuVisible(true) end)
local scroll=new('ScrollingFrame',{
 Position=UDim2.fromOffset(0,82),Size=UDim2.new(1,0,1,-94),
 BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
 ScrollBarImageColor3=Color3.fromRGB(99,210,224),CanvasSize=UDim2.fromOffset(0,812),
 ScrollingDirection=Enum.ScrollingDirection.Y,
},f)
controlParent=scroll
local function button(s,y,fn)
 local b=new('TextButton',{Text=s,Position=UDim2.fromOffset(20,y-82),Size=UDim2.fromOffset(320,34),BackgroundColor3=Color3.fromRGB(37,44,65),BorderSizePixel=0,TextColor3=Color3.fromRGB(233,238,255),TextSize=14,Font=Enum.Font.GothamMedium},controlParent)
 corner(b)
 b.AutoButtonColor=false
 b.TextXAlignment=Enum.TextXAlignment.Left
 new('UIPadding',{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14)},b)
 local border=new('UIStroke',{Color=Color3.fromRGB(72,90,124),Transparency=0.7,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},b)
 on(b.MouseEnter,function()
  Tween:Create(border,TweenInfo.new(0.14),{Transparency=0.05,Color=Color3.fromRGB(111,212,228)}):Play()
 end)
 on(b.MouseLeave,function()
  Tween:Create(border,TweenInfo.new(0.2),{Transparency=0.7,Color=Color3.fromRGB(72,90,124)}):Play()
 end)
 on(b.Activated,function() fn(b) end)
 return b
end
local function toggle(s,k,y)
 local track,knob
 local function refresh(b)
  b.Text=s
  b.TextColor3=cfg[k] and Color3.fromRGB(204,246,247) or Color3.fromRGB(168,181,208)
  b.BackgroundColor3=cfg[k] and Color3.fromRGB(31,59,70) or Color3.fromRGB(29,36,53)
  if track then
   Tween:Create(track,TweenInfo.new(0.16),{BackgroundColor3=cfg[k] and Color3.fromRGB(82,195,205) or Color3.fromRGB(67,78,101)}):Play()
   Tween:Create(knob,TweenInfo.new(0.16),{Position=UDim2.fromOffset(cfg[k] and 23 or 3,3)}):Play()
  end
 end
 local b=button(s,y,function(b) cfg[k]=not cfg[k]; refresh(b) end)
 track=new('Frame',{Size=UDim2.fromOffset(42,22),Position=UDim2.new(1,-46,0.5,-11),BackgroundColor3=Color3.fromRGB(67,78,101),BorderSizePixel=0,Active=false},b)
 corner(track,11)
 knob=new('Frame',{Size=UDim2.fromOffset(16,16),Position=UDim2.fromOffset(3,3),BackgroundColor3=Color3.fromRGB(239,248,255),BorderSizePixel=0,Active=false},track)
 corner(knob,8)
 refresh(b)
 table.insert(refreshers,function() refresh(b) end)
end
toggle('Aim assist','enabled',82)
local function number(s,k,y,lo,hi)
 text(s,y,14)
 local b=new('TextBox',{Text=tostring(cfg[k]),Position=UDim2.fromOffset(252,y-82),Size=UDim2.fromOffset(88,30),BackgroundColor3=Color3.fromRGB(37,44,65),TextColor3=Color3.fromRGB(233,238,255),TextSize=14,Font=Enum.Font.Gotham,ClearTextOnFocus=false},controlParent)
 corner(b)
 on(b.FocusLost,function()
  local n=tonumber(b.Text)
  if n and n==n then cfg[k]=math.clamp(n,lo,hi) end
  b.Text=tostring(cfg[k])
 end)
end
number('Speed (1-40)','speed',128,1,40)
number('Radius, px (25-5000)','radius',170,25,5000)
toggle('Skip teammates','teams',212)
toggle('Check walls','walls',254)
toggle('Auto fire','autofire',296)
number('Shot interval, seconds','interval',338,0.05,2)
local choosing=false
local latched=false
local function keyName()
 return cfg.key==Enum.UserInputType.MouseButton2 and 'RMB' or cfg.key.Name
end
toggle('ESP · player outlines','esp',380)
toggle('Show aim radius','showRadius',422)
toggle('Keep selected target','sticky',464)
number('Max distance, studs','maxDistance',506,25,10000)
local kb=button('Aim key: RMB',548,function(b)
 choosing=true; latched=false; b.Text='Press keyboard key or RMB (Esc: cancel)'
end)
button('Mode: HOLD',590,function(b)
 cfg.toggleMode=not cfg.toggleMode
 latched=false
 b.Text=cfg.toggleMode and 'Mode: TOGGLE' or 'Mode: HOLD'
end)
toggle('Diagnostic output','debug',632)
toggle('ESP names / health / distance','espLabels',674)
toggle('FPS overlay','hud',716)
button('ESP color: 1 / 4',758,function(b)
 cfg.espColor=cfg.espColor % #palette + 1
 b.Text='ESP color: '..cfg.espColor..' / 4'
 b.TextColor3=palette[cfg.espColor]
end)
local status=text('Aim assist is OFF',800,11)
status.TextColor3=Color3.fromRGB(133,206,217)
status.TextTruncate=Enum.TextTruncate.AtEnd
local unload=button('Unload script',842,function() g:Destroy() end)
unload.BackgroundColor3=Color3.fromRGB(65,36,49)
unload.TextColor3=Color3.fromRGB(250,166,181)
-- Tabs group existing controls; their callbacks and configuration stay shared.
scroll.Position=UDim2.fromOffset(0,116)
scroll.Size=UDim2.new(1,0,1,-128)
local tabNames={'Aim','Fire','ESP','System'}
local tabButtons={}
local tabRows={Aim={},Fire={},ESP={},System={}}
local function category(y)
 if y==296 or y==338 then return 'Fire' end
 if y==380 or y==674 or y==758 then return 'ESP' end
 if y==632 or y==716 or y==800 or y==842 then return 'System' end
 return 'Aim'
end
for _,control in ipairs(scroll:GetChildren()) do
 if control:IsA('GuiObject') then
  local originalY=control.Position.Y.Offset+82
  local group=tabRows[category(originalY)]
  if not group[originalY] then group[originalY]={} end
  table.insert(group[originalY],control)
 end
end
local tabContents={}
local tabHeights={}
for _,name in ipairs(tabNames) do
 local positions={}
 for y in pairs(tabRows[name]) do table.insert(positions,y) end
 table.sort(positions)
 tabContents[name]={}
 for index,y in ipairs(positions) do
  for _,control in ipairs(tabRows[name][y]) do
   control.Position=UDim2.new(control.Position.X.Scale,control.Position.X.Offset,0,8+(index-1)*44)
   table.insert(tabContents[name],control)
  end
 end
 tabHeights[name]=#positions*44+16
end
local function selectTab(name)
 for _,other in ipairs(tabNames) do
  local selected=other==name
  for _,control in ipairs(tabContents[other]) do control.Visible=selected end
  local b=tabButtons[other]
  b.BackgroundColor3=selected and Color3.fromRGB(38,89,103) or Color3.fromRGB(28,35,52)
  b.TextColor3=selected and Color3.fromRGB(171,242,247) or Color3.fromRGB(145,160,189)
 end
 scroll.CanvasPosition=Vector2.new(0,0)
 scroll.CanvasSize=UDim2.fromOffset(0,tabHeights[name])
end
for index,name in ipairs(tabNames) do
 local tabName=name
 local b=new('TextButton',{
  Text=tabName,Position=UDim2.fromOffset(20+(index-1)*82,80),Size=UDim2.fromOffset(74,28),
  BackgroundColor3=Color3.fromRGB(28,35,52),BorderSizePixel=0,
  TextColor3=Color3.fromRGB(145,160,189),Font=Enum.Font.GothamMedium,TextSize=12,
 },f)
 corner(b,8)
 tabButtons[tabName]=b
 on(b.Activated,function() selectTab(tabName) end)
end
selectTab('Aim')
local dragging,start,pos
on(title.InputBegan,function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; start=i.Position; pos=f.Position end
end)
on(U.InputChanged,function(i)
 if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
  local d=i.Position-start
  f.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
 end
end)
on(U.InputEnded,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
local function matches(i)
 return cfg.key==Enum.UserInputType.MouseButton2
  and i.UserInputType==Enum.UserInputType.MouseButton2
  or i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==cfg.key
end
on(U.InputBegan,function(i)
 if choosing then
  if i.UserInputType==Enum.UserInputType.MouseButton2 then
   cfg.key=Enum.UserInputType.MouseButton2
  elseif i.UserInputType==Enum.UserInputType.Keyboard then
   if i.KeyCode~=Enum.KeyCode.Escape and i.KeyCode~=Enum.KeyCode.RightShift and i.KeyCode~=Enum.KeyCode.End and i.KeyCode~=Enum.KeyCode.Unknown then cfg.key=i.KeyCode end
  else return end
  choosing=false; latched=false; kb.Text='Aim key: '..keyName()
  return
 end
 if U:GetFocusedTextBox() then return end
 if i.KeyCode==Enum.KeyCode.End then
  cfg.enabled=false; cfg.autofire=false; cfg.esp=false; cfg.showRadius=false; cfg.hud=false
  latched=false
  for _,refresh in ipairs(refreshers) do refresh() end
  return
 end
 if i.KeyCode==Enum.KeyCode.RightShift then
  setMenuVisible(not f.Visible)
  latched=false
 elseif cfg.enabled and not f.Visible and cfg.toggleMode and matches(i) then
  latched=not latched
 end
end)
local focused=true
on(U.WindowFocusReleased,function() focused=false; latched=false end)
on(U.WindowFocused,function() focused=true end)
local function aimActive()
 if cfg.toggleMode then return latched end
 if cfg.key==Enum.UserInputType.MouseButton2 then
  return U:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
 end
 return U:IsKeyDown(cfg.key)
end
local lastShot=0
local lastDiagnostic=0
local clickSupported=type(mouse1press)=='function' and type(mouse1release)=='function'
local firing=false
local releaseAt=0
local function releaseShot()
 if firing then
  local ok,err=pcall(mouse1release)
  firing=false
  if not ok then
   clickSupported=false
   warn('Auto fire release failed: '..tostring(err))
  end
 end
end
local locked
local function target(p,c,params)
 if p==me then return end
 if cfg.teams and not me.Neutral and not p.Neutral and me.Team==p.Team then return end
 local ch=p.Character
 local h=ch and ch:FindFirstChild('Head')
 local hum=ch and ch:FindFirstChildOfClass('Humanoid')
 if not h or not h:IsA('BasePart') or not hum or hum.Health<=0 then return end
 if (h.Position-c.CFrame.Position).Magnitude>cfg.maxDistance then return end
 local v,visible=c:WorldToViewportPoint(h.Position)
 if not visible or v.Z<=0 then return end
 local d=(Vector2.new(v.X,v.Y)-c.ViewportSize/2).Magnitude
 if d>cfg.radius then return end
 if cfg.walls then
  local hit=workspace:Raycast(c.CFrame.Position,h.Position-c.CFrame.Position,params)
  if hit and not hit.Instance:IsDescendantOf(ch) then return end
 end
 return h,d
end
-- ESP is independent of aim activation and the menu's visibility.
local outlines={}
local function clearESP()
 for p,h in pairs(outlines) do h:Destroy(); outlines[p]=nil end
end
local function updateESP()
 if not cfg.esp then clearESP(); return end
 local present={}
 for _,p in ipairs(P:GetPlayers()) do
  local ch=p.Character
  local hum=ch and ch:FindFirstChildOfClass('Humanoid')
  local ally=cfg.teams and not me.Neutral and not p.Neutral and me.Team==p.Team
  if p~=me and not ally and ch and ch.Parent and hum and hum.Health>0 then
   present[p]=true
   local h=outlines[p]
   if h and (h.Adornee~=ch or not h.Parent) then
    h:Destroy(); outlines[p]=nil; h=nil
   end
   if not h then
    h=new('Highlight',{
     Name='SmoothAimESP',Adornee=ch,
     DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,
     FillColor=Color3.fromRGB(255,75,95),FillTransparency=0.8,
     OutlineColor=Color3.fromRGB(255,125,140),OutlineTransparency=0,
    },ch)
    outlines[p]=h
   end
   local color=palette[cfg.espColor]
   h.FillColor=color; h.OutlineColor=color
   local head=ch:FindFirstChild('Head')
   local tag=h:FindFirstChild('PlayerInfo')
   if cfg.espLabels and head and head:IsA('BasePart') then
    if not tag then
     tag=new('BillboardGui',{
      Name='PlayerInfo',Adornee=head,AlwaysOnTop=true,
      Size=UDim2.fromOffset(200,48),StudsOffsetWorldSpace=Vector3.new(0,2,0),
     },h)
     new('TextLabel',{
      Name='Info',Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
      Font=Enum.Font.GothamBold,TextSize=12,TextColor3=color,
      TextStrokeTransparency=0.2,TextStrokeColor3=Color3.fromRGB(10,14,20),
     },tag)
    end
    tag.Adornee=head; tag.MaxDistance=cfg.maxDistance
    local camera=workspace.CurrentCamera
    local distance=camera and (head.Position-camera.CFrame.Position).Magnitude or 0
    tag.Info.TextColor3=color
    tag.Info.Text=string.format('%s\n%d / %d HP  |  %d studs',p.DisplayName,
     math.floor(hum.Health),math.floor(hum.MaxHealth),math.floor(distance))
   elseif tag then tag:Destroy() end
  end
 end
 for p,h in pairs(outlines) do
  if not present[p] then h:Destroy(); outlines[p]=nil end
 end
end
local espTime=0
on(R.Heartbeat,function(dt)
 espTime=espTime+dt
 if espTime>=0.2 then espTime=0; updateESP() end
end)
local hud=new('TextLabel',{
 Name='PerformanceHUD',Position=UDim2.new(1,-218,0,18),Size=UDim2.fromOffset(200,38),
 BackgroundColor3=Color3.fromRGB(18,25,38),BackgroundTransparency=0.15,
 BorderSizePixel=0,TextColor3=Color3.fromRGB(151,229,238),
 TextSize=12,Font=Enum.Font.GothamMedium,Visible=false,Text='FPS: --',
},g)
corner(hud,10)
local frameCount,frameTime=0,0
on(R.RenderStepped,function(dt)
 hud.Visible=cfg.hud
 frameCount=frameCount+1; frameTime=frameTime+dt
 if frameTime>=0.5 then
  if cfg.hud then
   local count=0
   for _ in pairs(outlines) do count=count+1 end
   hud.Text=string.format('%d FPS  |  ESP: %d',math.floor(frameCount/frameTime+0.5),count)
  end
  frameCount=0; frameTime=0
 end
end)
-- Intersect the camera ray with the head's oriented bounding box.
-- A separate character Hitbox may be the first physical raycast hit.
local function rayCrossesHead(ray,head,maxDistance)
 local origin=head.CFrame:PointToObjectSpace(ray.Origin)
 local direction=head.CFrame:VectorToObjectSpace(ray.Direction)
 local half=head.Size*0.5
 local near,far=0,maxDistance
 for _,axis in ipairs({'X','Y','Z'}) do
  local o,d,b=origin[axis],direction[axis],half[axis]
  if math.abs(d)<1e-7 then
   if o < -b or o > b then return false end
  else
   local a,z=(-b-o)/d,(b-o)/d
   if a>z then a,z=z,a end
   near=math.max(near,a)
   far=math.min(far,z)
   if near>far then return false end
  end
 end
 return true
end
local radiusRing=new('Frame',{
 AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,
 Size=UDim2.fromOffset(cfg.radius*2,cfg.radius*2),BorderSizePixel=0,Visible=false,
},g)
corner(radiusRing,10000)
new('UIStroke',{Color=Color3.fromRGB(100,218,229),Transparency=0.35,Thickness=1},radiusRing)
local bind='AimSettingsCamera'
R:UnbindFromRenderStep('SmoothAim')
R:UnbindFromRenderStep(bind)
R:BindToRenderStep(bind,Enum.RenderPriority.Camera.Value+1,function(dt)
 fitMenu()
 local view=workspace.CurrentCamera
 radiusRing.Visible=cfg.showRadius and not f.Visible and view~=nil
 if view then
  radiusRing.Position=UDim2.fromOffset(view.ViewportSize.X/2,view.ViewportSize.Y/2)
  radiusRing.Size=UDim2.fromOffset(cfg.radius*2,cfg.radius*2)
 end
 if firing and (os.clock()>=releaseAt or not cfg.enabled or not cfg.autofire
  or choosing or f.Visible or not focused or U:GetFocusedTextBox() or not aimActive()) then
  releaseShot()
 end
 if not cfg.enabled or choosing or f.Visible or not focused or U:GetFocusedTextBox() then
  locked=nil; latched=false
  status.Text=cfg.enabled and 'Close menu to aim' or 'Aim assist is OFF'
  return
 end
 if not aimActive() then
  locked=nil
  status.Text=(cfg.toggleMode and 'Press ' or 'Hold ')..keyName()..' to aim'
  return
 end
 local c=workspace.CurrentCamera
 if not c then return end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=me.Character and {me.Character,c} or {c}
 local h=cfg.sticky and locked and target(locked,c,params)
 if not h then
  locked=nil
  local best=cfg.radius
  for _,p in ipairs(P:GetPlayers()) do
   local part,d=target(p,c,params)
   if part and d<=best then locked=p; h=part; best=d end
  end
 end
 status.Text=locked and ('Target: '..locked.DisplayName) or 'No visible target in radius'
 if h then
  c.CFrame=c.CFrame:Lerp(CFrame.lookAt(c.CFrame.Position,h.Position),1-math.exp(-cfg.speed*dt))
  if cfg.autofire then
   if not clickSupported then
    status.Text='Auto fire unavailable: press/release missing or failed'
   elseif f.Visible then
    status.Text='Hide menu with RightShift to auto fire'
   elseif not U:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
    -- Check the actual center ray after smoothing, including walls.
    local ray=c:ViewportPointToRay(c.ViewportSize.X/2,c.ViewportSize.Y/2)
    local distance=(h.Position-ray.Origin).Magnitude+h.Size.Magnitude
    local hit=workspace:Raycast(ray.Origin,ray.Direction*distance,params)
    local aligned=hit~=nil and hit.Instance:IsDescendantOf(h.Parent)
     and rayCrossesHead(ray,h,distance)
    local now=os.clock()
    if cfg.debug and now-lastDiagnostic>=2 then
     lastDiagnostic=now
     print('[Auto fire] target:',h:GetFullName(),
      '| ray hit:',hit and hit.Instance:GetFullName() or 'nothing',
      '| aligned:',aligned)
    end
    if not firing and aligned and now-lastShot>=math.max(cfg.interval,0.18) then
     lastShot=now
     firing=true
     releaseAt=now+0.15
     if cfg.debug then print('[Auto fire] PRESS') end
     local ok=pcall(mouse1press)
     if not ok then
      releaseShot()
      clickSupported=false
      status.Text='Auto fire stopped: click failed'
      warn('Auto fire: mouse1press failed; reload the script to retry')
     end
    end
   end
  end
 end
end)
on(g.Destroying,function()
 releaseShot()
 clearESP()
 R:UnbindFromRenderStep(bind)
 for _,c in ipairs(links) do c:Disconnect() end
end)

















