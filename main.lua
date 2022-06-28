--// DXLib //--


--// Presets for supg's smol brain to rember
local Game = dx9.GetDatamodel();
local Workspace = dx9.FindFirstChild(Game,"Workspace");
local Mouse = dx9.GetMouse();
local LocalPlayer = dx9.get_localplayer();
local Players = dx9.get_players();

local Screen = {
    x = dx9.size().width;
    y = dx9.size().height;
}

--// Initiating Library
if _G.dxl == nil then
    _G.dxl = {
        --// Console Vars
        Location = {1000, 150}; -- Dynamic
        Size = {dx9.size().width / 2.95, dx9.size().height / 1.21}; -- Static
        FontColor = {255,255,255}; -- Static + [Changeable]
        MainColor = {25,25,25}; -- Static + [Changeable]
        BackgroundColor = {15,15,15}; -- Static + [Changeable]
        AccentColor = {255,100,255}; -- Static + [Changeable]
        OutlineColor = {40,40,40}; -- Static + [Changeable]
        Black = {0,0,0}; -- Static

        ErrorColor = {255,100,100};

        WinMouseOffset = nil;

        StoredLogs = {};

        Open = true;

        Hovering = false;

        --// Storing older functions and stuff :3
        LoadstringCaching = {};
        GetCaching = {};
        OldLoadstring = loadstring;
        OldGet = dx9.Get;

        OldPrint = print;
        OldError = error;

        --// Sleep
        Threads = {};

        --// Dragging
        Dragging = false;

        --// Character Stuff (saved for optimization)
        Characters = {};
        PlayerFolder = nil;

        --// Rainbow
        CurrentRainbowColor = {255,255,255};
        RainbowHue = 0;
    };
end


--// Rainbow Tick
do
    if dxl.RainbowHue > 1530 then
        dxl.RainbowHue = 0  
    else
        dxl.RainbowHue = dxl.RainbowHue + 3
    end

    if dxl.RainbowHue <= 255 then
        dxl.CurrentRainbowColor = {255, dxl.RainbowHue, 0}
    elseif dxl.RainbowHue <= 510 then
        dxl.CurrentRainbowColor = {510 - dxl.RainbowHue, 255, 0}
    elseif dxl.RainbowHue <= 765 then
        dxl.CurrentRainbowColor = {0, 255, dxl.RainbowHue - 510}
    elseif dxl.RainbowHue <= 1020 then
        dxl.CurrentRainbowColor = {0, 1020 - dxl.RainbowHue, 255}
    elseif dxl.RainbowHue <= 1275 then
        dxl.CurrentRainbowColor = {dxl.RainbowHue - 1020, 0, 255}
    elseif dxl.RainbowHue <= 1530 then
        dxl.CurrentRainbowColor = {255, 0, 1530 - dxl.RainbowHue}
    end
end


--// Threads (temp)

local ThreadCount = 0

function sleep(v, index)
    ThreadCount = ThreadCount + 1

    assert(type(v) == "number" and v >= 0, "[DXL Error] sleep: First Argument needs to be a number above 0!")

    if v == 0 then
        dxl.Threads[ThreadCount] = nil
        --ThreadCount = ThreadCount - 1
        return true 
    end

    local total_seconds = (os.date("*t").hour * 3600) + (os.date("*t").min * 60) + (os.date("*t").sec)

    if dxl.Threads[ThreadCount] == nil then
        local largest_end = total_seconds

        if index ~= nil then
            for i,f in pairs(dxl.Threads) do
                if f.Index == index then
                    if f.End > largest_end then
                        largest_end = f.End
                    end
                end
            end
        end

        dxl.Threads[ThreadCount] = {
            End = largest_end + v;
            Index = index;
        }
    else
    
        if total_seconds >= dxl.Threads[ThreadCount].End then
            dxl.Threads[ThreadCount] = nil
            --ThreadCount = ThreadCount - 1
            return true 
        end
    end
    return false
end


--[[
██████╗  █████╗ ███████╗██╗ ██████╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔══██╗██╔══██╗██╔════╝██║██╔════╝    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██████╔╝███████║███████╗██║██║         █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██╔══██╗██╔══██║╚════██║██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
██████╔╝██║  ██║███████║██║╚██████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]


--// Not sure if each screen is a different size (dx9.size) so I'm using this to use % instead of Pixels to click / move to screen coords
function dxl.GetCoords(wts)
    assert(type(wts) == "table" and #wts == 2, "[DXL Error] GetCoords: First Argument needs to be a table with 2 values!")

    --// Divides my screen size by my input coords to get %, then turns the % into a screen coord that corisponds with the client's screen size
    return {(Screen.x / (1920 / wts[1])), (Screen.y / (1017 / wts[2]))} 
end


--[[
██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗  █████╗ ██████╗ ██╗   ██╗     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║██████╔╝ ╚████╔╝     ██║     ███████║█████╗  ██║     █████╔╝ 
██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║██╔══██╗  ╚██╔╝      ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ 
██████╔╝╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║██║  ██║   ██║       ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
]]

function dxl.isMouseInArea(area)
    assert(type(area) == "table" and #area == 4, "[DXL Error] isMouseInArea: First Argument needs to be a table with 4 values!")

    if dx9.GetMouse().x > area[1] and dx9.GetMouse().y > area[2] and dx9.GetMouse().x < area[3] and dx9.GetMouse().y < area[4] then
        return true
    else
        return false
    end
end


--[[
 ██████╗ ███████╗████████╗    ██████╗ ██╗███████╗████████╗ █████╗ ███╗   ██╗ ██████╗███████╗
██╔════╝ ██╔════╝╚══██╔══╝    ██╔══██╗██║██╔════╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██╔════╝
██║  ███╗█████╗     ██║       ██║  ██║██║███████╗   ██║   ███████║██╔██╗ ██║██║     █████╗  
██║   ██║██╔══╝     ██║       ██║  ██║██║╚════██║   ██║   ██╔══██║██║╚██╗██║██║     ██╔══╝  
╚██████╔╝███████╗   ██║       ██████╔╝██║███████║   ██║   ██║  ██║██║ ╚████║╚██████╗███████╗
 ╚═════╝ ╚══════╝   ╚═╝       ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]

function dxl.GetDistance(v, i)
    local v1 = {}
    local v2 = {}

    if type(i) == "table" then
        if i['x'] ~= nil and i['y'] ~= nil and i['z'] ~= nil then
            v1 = i
        else
            assert(type(i) == "table" and #i == 3, "[DXL Error] GetDistance: Second Argument needs to be a table with 3 values!")
            v1['x'] = i[1]
            v1['y'] = i[2]
            v1['z'] = i[3]
        end
    elseif type(i) == "number" then
        assert(type(i) == "number" and dx9.GetPosition(i), "[DXL Error] GetDistance: Second Argument needs to be a number (pointer)!")
        v1 = dx9.GetPosition(i);
    else
        error("[DXL Error] GetDistance: Second Argument needs to be a table (with position values) or number (instance)!\n".. debug.traceback().."\n")
        return;
    end

    if type(v) == "table" then
        if v['x'] ~= nil and v['y'] ~= nil and v['z'] ~= nil then
            v2 = v
        else
            assert(type(v) == "table" and #v == 3, "[DXL Error] GetDistance: First Argument needs to be a table with 3 values!")

            v2['x'] = v[1]
            v2['y'] = v[2]
            v2['z'] = v[3]
        end
    elseif type(v) == "number" then
        assert(type(v) == "number" and dx9.GetPosition(v), "[DXL Error] GetDistance: First Argument needs to be a number (pointer)!")
        v2 = dx9.GetPosition(v);
    else
        error("[DXL Error] GetDistance: First Argument needs to be a table (with position values) or number (instance)!\n".. debug.traceback().."\n")
        return;
    end

    local a = (v1.x-v2.x)*(v1.x-v2.x);
    local b = (v1.y-v2.y)*(v1.y-v2.y);
    local c = (v1.z-v2.z)*(v1.z-v2.z);

    return math.floor(math.sqrt(a+b+c)+0.5);
end


--// Get Distance From Player
function dxl.GetDistanceFromPlayer(v)
    return dxl.GetDistance(v, dx9.get_localplayer().Position)
end


--[[
██╗  ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗██████╗  █████╗ ██████╗ 
██║  ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║██╔══██╗██╔══██╗██╔══██╗
███████║█████╗  ███████║██║     ██║   ███████║██████╔╝███████║██████╔╝
██╔══██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║██╔══██╗██╔══██║██╔══██╗
██║  ██║███████╗██║  ██║███████╗██║   ██║  ██║██████╔╝██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
{TargetPosition = {x, y, z}, Size = {x, y}, HP = hp, MaxHP = max_hp, Scale = false, Offset = {x, y}}
]]

function dxl.HealthBar(params)
    --// Variable Insurance
    local size = params.Size or {120, 5}
    local size_x = size[1]
    local size_y = size[2]

    local maxhp = params.MaxHP or 100

    local scale = params.Scale or false

    local offset = params.Offset or {0,0}

    --// Error Handling
    local pos = {}

    if params.TargetPosition.x and params.TargetPosition.y and params.TargetPosition.z and type(params.TargetPosition.x) == "number" and type(params.TargetPosition.y) == "number" and type(params.TargetPosition.z) == "number" then
        pos = {params.TargetPosition.x, params.TargetPosition.y, params.TargetPosition.z}

    elseif params.TargetPosition[1] and params.TargetPosition[2] and params.TargetPosition[3] and type(params.TargetPosition[1]) == "number" and type(params.TargetPosition[2]) == "number" and type(params.TargetPosition[3]) == "number" then 
        if #params.TargetPosition == 3 then 
            pos = {params.TargetPosition[1], params.TargetPosition[2], params.TargetPosition[3]}
        else
            error("[DXL Error] HealthBar: TargetPosition Argument needs to contain 3 number values! (x, y, z)\n".. debug.traceback().."\n")
            return;
        end
    else
        error("[DXL Error] HealthBar: TargetPosition Argument needs to contain 3 number values! (x, y, z)\n".. debug.traceback().."\n")
        return;
    end

    assert(type(pos) == "table" and #pos == 3, "[DXL Error] HealthBar: TargetPosition Argument needs to be a table with 3 values!")
    assert(type(params.HP) == "number", "[DXL Error] HealthBar: HP Argument needs to be a number!")

    local hp = params.HP

    if not scale then
        local wts = dx9.WorldToScreen(pos);

        local x = wts.x
        local y = wts.y


        --// A lot of math stuff, dont mess with it unless u know what ur doing
        local temp = ((size_x - 2) / ( maxhp/math.max(0, math.min(maxhp, hp))));

        dx9.DrawFilledBox({x - (size_x/2) + offset[1], y + offset[2]}, {x + (size_x/2) + offset[1], y - size_y + offset[2]}, {0,0,0});
        dx9.DrawFilledBox({x - ((size_x/2) - 1) + offset[1], y - 1 + offset[2]}, {x - ((size_x/2) - 1) + temp + offset[1], y - (size_y - 1) + offset[2]},   {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0});

    else
        size_x = size_x / 10
        size_y = size_y / 10
        --// AIDS BELOW (WATCH OUT) (WARNING) (DANGER)
        local wts1 = dx9.WorldToScreen({pos[1] - (size_x/2), pos[2] - (size_y/2), pos[3]});
        local wts2 = dx9.WorldToScreen({pos[1] + (size_x/2), pos[2] + (size_y/2), pos[3]});
        

        --// A lot of math stuff, dont mess with it unless u know what ur doing
        --local temp = ((size_x - 2) / ( maxhp/math.max(0, math.min(maxhp, hp))));
        
        dx9.DrawFilledBox({wts1.x, wts1.y}, {wts2.x, wts2.y}, {0,0,0});
        
        dx9.DrawFilledBox({wts1.x + 1, wts1.y - 1}, {wts2.x - 1     , wts2.y + 1},            {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0});
    end
end


--[[
██████╗ ██████╗     ██████╗  ██████╗ ██╗  ██╗
╚════██╗██╔══██╗    ██╔══██╗██╔═══██╗╚██╗██╔╝
 █████╔╝██║  ██║    ██████╔╝██║   ██║ ╚███╔╝ 
 ╚═══██╗██║  ██║    ██╔══██╗██║   ██║ ██╔██╗ 
██████╔╝██████╔╝    ██████╔╝╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
]]

function dxl.Box3d(pos1, pos2, box_color) 

    --// Error Handling
    assert(type(pos1) == "table" and #pos1 == 3, "[DXL Error] Box3d: First Argument needs to be a table with 3 position values!")
    assert(type(pos2) == "table" and #pos2 == 3, "[DXL Error] Box3d: Second Argument needs to be a table with 3 position values!")
    assert(type(box_color) == "table" and #box_color == 3, "[DXL Error] Box3d: Third Argument needs to be a table with 3 RGB values!")

    local c1 = pos1 --// POSITIVE
    local c2 = pos2 --// NEGATIVE

    local v1 = dx9.WorldToScreen(c1);
    local v2 = dx9.WorldToScreen(c2);

    local v3 = dx9.WorldToScreen({c2[1], c2[2], c1[3]})
    local v4 = dx9.WorldToScreen({c2[1], c1[2], c1[3]})

    local v5 = dx9.WorldToScreen({c1[1], c1[2], c2[3]})
    local v6 = dx9.WorldToScreen({c1[1], c2[2], c2[3]})

    local v7 = dx9.WorldToScreen({c2[1], c1[2], c2[3]})
    local v8 = dx9.WorldToScreen({c1[1], c2[2], c1[3]})

    --// Supg did the stuff below (took me 5 minutes and 47 seconds flat)
    dx9.DrawLine({v4.x, v4.y}, {v1.x, v1.y}, box_color) -- Top Front
    dx9.DrawLine({v7.x, v7.y}, {v5.x, v5.y}, box_color) -- Top Back

    dx9.DrawLine({v7.x, v7.y}, {v4.x, v4.y}, box_color) -- Top Left
    dx9.DrawLine({v5.x, v5.y}, {v1.x, v1.y}, box_color) -- Top Right

    dx9.DrawLine({v3.x, v3.y}, {v8.x, v8.y}, box_color) -- Bottom Front
    dx9.DrawLine({v2.x, v2.y}, {v6.x, v6.y}, box_color) -- Bottom Back

    dx9.DrawLine({v2.x, v2.y}, {v3.x, v3.y}, box_color) -- Bottom Left
    dx9.DrawLine({v6.x, v6.y}, {v8.x, v8.y}, box_color) -- Bottom Right {v1.x, v1.y}

    dx9.DrawLine({v1.x, v1.y}, {v8.x, v8.y}, box_color) -- Front Right
    dx9.DrawLine({v4.x, v4.y}, {v3.x, v3.y}, box_color) -- Front Left

    dx9.DrawLine({v5.x, v5.y}, {v6.x, v6.y}, box_color) -- Back Right
    dx9.DrawLine({v7.x, v7.y}, {v2.x, v2.y}, box_color) -- Back Left
end


--[[
██████╗  ██████╗ ██╗  ██╗██████╗ ██████╗ 
██╔══██╗██╔═══██╗╚██╗██╔╝╚════██╗██╔══██╗
██████╔╝██║   ██║ ╚███╔╝  █████╔╝██║  ██║
██╔══██╗██║   ██║ ██╔██╗ ██╔═══╝ ██║  ██║
██████╔╝╚██████╔╝██╔╝ ██╗███████╗██████╔╝
╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ 
]]

function dxl.Box2d(pos_list, box_color) 

    --// Error Handling
    assert(type(pos_list) == "table" and #pos_list == 4, "[DXL Error] Box3d: First Argument needs to be a table with 4 values!")
    assert(type(box_color) == "table" and #box_color == 3, "[DXL Error] Box3d: Second Argument needs to be a table with 3 RGB values!")

    assert(type(pos_list[1]) == "table" and #pos_list[1] == 3, "[DXL Error] Box3d: First Argument needs to be a table with 4 x,y,z values!")
    assert(type(pos_list[2]) == "table" and #pos_list[2] == 3, "[DXL Error] Box3d: First Argument needs to be a table with 4 x,y,z values!")
    assert(type(pos_list[3]) == "table" and #pos_list[3] == 3, "[DXL Error] Box3d: First Argument needs to be a table with 4 x,y,z values!")
    assert(type(pos_list[4]) == "table" and #pos_list[4] == 3, "[DXL Error] Box3d: First Argument needs to be a table with 4 x,y,z values!")

    local TL = dx9.WorldToScreen(pos_list[1])
    local TR = dx9.WorldToScreen(pos_list[2])
    local BL = dx9.WorldToScreen(pos_list[3])
    local BR = dx9.WorldToScreen(pos_list[4])

    dx9.DrawLine({TL.x, TL.y}, {TR.x, TR.y}, box_color) -- Top
    dx9.DrawLine({BL.x, BL.y}, {BR.x, BR.y}, box_color) -- Bottom
    dx9.DrawLine({TR.x, TR.y}, {BR.x, BR.y}, box_color) -- Right
    dx9.DrawLine({BL.x, BL.y}, {TL.x, TL.y}, box_color) -- Left

end


--[[
██████╗  ██████╗ ██╗  ██╗    ███████╗███████╗██████╗ 
██╔══██╗██╔═══██╗╚██╗██╔╝    ██╔════╝██╔════╝██╔══██╗
██████╔╝██║   ██║ ╚███╔╝     █████╗  ███████╗██████╔╝
██╔══██╗██║   ██║ ██╔██╗     ██╔══╝  ╚════██║██╔═══╝ 
██████╔╝╚██████╔╝██╔╝ ██╗    ███████╗███████║██║     
╚═════╝  ╚═════╝ ╚═╝  ╚═╝    ╚══════╝╚══════╝╚═╝     
]]

--// BOX BoxESP
function dxl.BoxESP(params) -- params = {*Target = model, Color = {r,g,b}, Healthbar = false, Distance = false, Nametag = false, Tracer = false, TracerType = "mouse", BoxType = 1} 

    local target = params.Target or nil
    local box_color = params.Color or {255,255,255}
    local healthbar = params.Healthbar or false
    local distance = params.Distance or false
    local nametag = params.Nametag or false
    local tracer = params.Tracer or false
    local tracertype = string.lower(params.TracerType) or "mouse"
    local box_type = params.BoxType or 1 --// 1 = corners, 2 = 2d box, 3 = 3d box

    --// Error Handling
    assert(type(box_type) == "number" and (box_type == 1 or box_type == 2 or box_type == 3), "[DXL Error] BoxESP: BoxType Argument needs to be a number! (see docs)")
    assert(type(target) == "number" and dx9.GetChildren(target) ~= nil, "[DXL Error] BoxESP: Target Argument needs to be a number (pointer) to character!")
    assert(type(box_color) == "table" and #box_color == 3, "[DXL Error] BoxESP: Color Argument needs to be a table with 3 RGB values!")

    if dx9.FindFirstChild(target, "HumanoidRootPart") and dx9.GetPosition(dx9.FindFirstChild(target, "HumanoidRootPart")) then
        local torso = dx9.GetPosition(dx9.FindFirstChild(target, "HumanoidRootPart"))

        local HeadPosY = torso.y + 2.5
        local LegPosY = torso.y - 3.5

        --// yusuf code  
        --[[
        local top = dx9.WorldToScreen({torso.x , HeadPosY, torso.z})
        local bottom = dx9.WorldToScreen({torso.x , LegPosY, torso.z})

        local myheight = bottomPositon.y - topPosition.y
        local mywidth = (myheight / 2) / 1,2

        local TopLeft(hrpPosition.x - mywidth, hrpPosition.y - myheight)
        local BottomRight(hrpPosition.x + mywidth, hrpPosition.y)
        
        DrawFilledBox(TopLeft, BottomRight, Colours::background_colour)

        ]]

        local Top = dx9.WorldToScreen({torso.x , HeadPosY, torso.z})
        local Bottom = dx9.WorldToScreen({torso.x , LegPosY, torso.z})

        local height = Top.y - Bottom.y

        local width = (height / 2) 
        width = width / 1.2

        

        --// Draw Box
        if box_type == 1 then --// cormers
            dx9.DrawLine({Top.x + width + 2, Top.y}, {Top.x + (width/2) + 2, Top.y}, box_color) -- TopLeft 1
            dx9.DrawLine({Top.x + width + 2, Top.y}, {Top.x + width + 2, Top.y - (height/4)}, box_color) -- TopLeft 2

            dx9.DrawLine({Bottom.x - width, Top.y}, {Bottom.x - (width/2), Top.y}, box_color) -- TopRight 1
            dx9.DrawLine({Bottom.x - width, Top.y}, {Bottom.x - width, Top.y - (height/4)}, box_color) -- TopRight 2

            dx9.DrawLine({Top.x + width + 2, Bottom.y}, {Top.x + (width/2) + 2, Bottom.y}, box_color) -- BottomLeft 1
            dx9.DrawLine({Top.x + width + 2, Bottom.y}, {Top.x + width + 2, Bottom.y + (height/4)}, box_color) -- BottomLeft 2

            dx9.DrawLine({Bottom.x - width, Bottom.y}, {Bottom.x - (width/2), Bottom.y}, box_color) -- BottomRight 1
            dx9.DrawLine({Bottom.x - width, Bottom.y}, {Bottom.x - width, Bottom.y + (height/4)}, box_color) -- BottomRight 2

        elseif box_type == 2 then
            dx9.DrawBox({Bottom.x - width, Top.y}, {Top.x + width, Bottom.y}, box_color)
        else
            dxl.Box3d({torso.x - 2, HeadPosY, torso.z - 2}, {torso.x + 2, LegPosY, torso.z + 2}, box_color)
        end

        --dx9.DrawLine({TL.x - height/3, TL.y}, {TR.x + height/3, TR.y}, box_color) -- Top
        --dx9.DrawLine({BL.x - height/3, BL.y}, {BR.x + height/3, BR.y}, box_color) -- Bottom
        --dx9.DrawLine({TR.x + height/3, TR.y}, {BR.x + height/3, BR.y}, box_color) -- Right
        --dx9.DrawLine({BL.x - height/3, BL.y}, {TL.x - height/3, TL.y}, box_color) -- Left

        if healthbar then
            if dx9.FindFirstChild(target, "Humanoid") then
                local tl = {Top.x + width - 5, Top.y + 1}
                local br = {Top.x + width - 1, Bottom.y - 1}

                local humanoid = dx9.FindFirstChild(target, "Humanoid")
                local hp = dx9.GetHealth(humanoid)
                local maxhp = dx9.GetMaxHealth(humanoid)


                --// A lot of math stuff, dont mess with it unless u know what ur doing
                local addon = ( (height + 2) / ( maxhp/math.max(0, math.min(maxhp, hp))) )
                
                dx9.DrawBox({tl[1] - 1, tl[2] - 1}, {br[1] + 1, br[2] + 1}, box_color) -- Outer
                dx9.DrawFilledBox({tl[1], tl[2]}, {br[1], br[2]}, {0,0,0}) -- Inner Black
                dx9.DrawFilledBox({tl[1] + 1, br[2] - 1}, {br[1] - 1,    (br[2] + addon + 1)   }, {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0}) -- Inner

                --dx9.DrawFilledBox({x - (size_x/2) + offset[1], y + offset[2]}, {x + (size_x/2) + offset[1], y - size_y + offset[2]}, {0,0,0});
                --dx9.DrawFilledBox({x - ((size_x/2) - 1) + offset[1], y - 1 + offset[2]}, {x - ((size_x/2) - 1) + temp + offset[1], y - (size_y - 1) + offset[2]},   {255 - 255 / (maxhp / hp), 255 / (maxhp / hp), 0});
            else
                error("[DXL Error] BoxESP: Target has no humanoid, healthbar not added!")
            end
        end

        if distance then
            local dist = ""..dxl.GetDistanceFromPlayer(torso)
            dx9.DrawString({Bottom.x - (dx9.CalcTextWidth(dist) / 2), Bottom.y}, box_color, dist)
        end

        if nametag then
            local name = dx9.GetName(target)
            dx9.DrawString({Top.x - (dx9.CalcTextWidth(name) / 2), Top.y - 20}, box_color, name)
        end

        if tracer then
            local loc = {dx9.GetMouse().x, dx9.GetMouse().y} -- Location of tracer start

            if tracertype == "bottom" then
                loc = {dx9.size().width / 2, dx9.size().height / 1.1}
            end

            dx9.DrawLine(loc, {Top.x + width + (((Bottom.x - width) - (Top.x + width)) / 2), Bottom.y}, box_color)
        end
    else
        error("[DXL Error] BoxESP: Passed in target has no HumanoidRootPart!")
    end
end


--[[
 ██████╗  █████╗ ███╗   ███╗███████╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██║  ███╗███████║██╔████╔██║█████╗      █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]

function dxl.Game(...)
    local a = dx9.GetDatamodel()
    for c, d in pairs({...}) do
        a = dx9.FindFirstChild(a, d)
    end
    return a
end


--// Troll Command
--[[
function dxl.Troll()

    

    if sleep(3, "core1") then
        dx9.MouseMove(dxl.GetCoords({20, 1040}))
        dx9.Mouse1Click()
    end

    if sleep(1, "core1") then
        dx9.MouseMove(dxl.GetCoords({20, 990}))
        dx9.Mouse1Click()
    end

    if sleep(1, "core1") then
        dx9.MouseMove(dxl.GetCoords({20, 910}))
        --dx9.Mouse1Click() 
    end
end
]]


--// Get Descendants
function dxl.GetDescendants(instance)
    assert(type(instance) == "number" and dx9.GetChildren(instance) ~= nil, "[DXL Error] GetDescendants: First Argument needs to be a number (pointer)!")

    local children = {}
    for _, child in ipairs(dx9.GetChildren(instance)) do
        table.insert(children, child)
        if #dx9.GetChildren(child) > 0 then
            for i,v in pairs(dxl.GetDescendants(child)) do
                table.insert(children, v)
            end
        end
    end
    return children
end


--// Get Descendants of Class
function dxl.GetDescendantsOfClass(instance, class)
    assert(type(instance) == "number" and dx9.GetChildren(instance) ~= nil, "[DXL Error] GetDescendantsOfClass: First Argument needs to be a number (pointer)!")
    assert(type(class) == "string", "[DXL Error] GetDescendantsOfClass: Second Argument needs to be a string (class name)!")

    local children = {}
    for i,v in pairs(dxl.GetDescendants(instance)) do
        if dx9.GetType(v) == class then
            table.insert(children, v)
        end
    end
    return children
end


--// Get Closest Part
function dxl.GetClosestPart(target)
    assert(type(target) == "number" and dx9.GetChildren(target) ~= nil, "[DXL Error] GetClosestPart: First Argument needs to be a number (pointer)!")

    local closest_part
    local valid_classes = {
        Part = true;
        MeshPart = true;
        Accessory = true;
        TrussPart = true;
        WedgePart = true;
        CornerWedgePart = true;
        SpecialMesh = true;
        BlockMesh = true;
    };

    for i,v in pairs(dxl.GetDescendants(target)) do
        if valid_classes[dx9.GetType(v)] then
		if closest_part == nil then
			closest_part = v
		end
            if dxl.GetDistanceFromPlayer(dx9.GetPosition(v)) < dxl.GetDistanceFromPlayer(dx9.GetPosition(closest_part)) then
                closest_part = v;
            end
        end
    end
    return closest_part;
end


--[[
██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗     ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝    █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗    ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]

--// Get Local Player Name
function dxl.GetLocalPlayerName()
    return dx9.get_localplayer().Info.Name
end

--// Get Local Player
function dxl.GetLocalPlayer()
    return dxl.Game("Players", dxl.GetLocalPlayerName())
end

--// Get PlayerGui of Local Player
function dxl.GetLocalPlayerGUI()
    return dxl.Game("Players", dxl.GetLocalPlayerName(),"PlayerGui")
end

--// Get Player
function dxl.GetPlayer(name)
    return dx9.FindFirstChild(dxl.Game("Players"), name)
end

--// Get Player PlayerFolder (doesent work for some games)
function dxl.GetPlayerFolder()
    if dxl.PlayerFolder ~= nil then return dxl.PlayerFolder end

    for i,v in pairs(dxl.GetDescendants(dxl.Game("Workspace"))) do
        if dx9.GetName(v) == dxl.GetLocalPlayerName() and dx9.GetType(v) == "Model" then
            dxl.PlayerFolder = dx9.GetParent(v)
            return dx9.GetParent(v)
        end
    end
end

--// Get Character
function dxl.GetCharacter(var) 
    local name

    if type(var) == "number" and dx9.GetName(var) ~= nil then 
        name = dx9.GetName(var) 
    else 
        assert(type(var) == "string", "[DXL Error] GetCharacter: First Argument needs to be a string!")
        name = var 
    end

    if dxl.Characters[name] ~= nil then return dxl.Characters[name] end

    for i,v in pairs(dxl.GetDescendants(dxl.Game("Workspace"))) do
        if dx9.GetName(v) == name and dx9.GetType(v) == "Model" then
            dxl.Characters[dx9.GetName(v)] = v 
            return v
        end
    end

    return 0
end

--// Get Local Character
function dxl.GetLocalCharacter()
    return dxl.GetCharacter(dxl.GetLocalPlayer())
end


--[[
███╗   ███╗██╗███████╗ ██████╗    ███████╗██╗   ██╗███╗   ██╗ ██████╗███████╗
████╗ ████║██║██╔════╝██╔════╝    ██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝
██╔████╔██║██║███████╗██║         █████╗  ██║   ██║██╔██╗ ██║██║     ███████╗
██║╚██╔╝██║██║╚════██║██║         ██╔══╝  ██║   ██║██║╚██╗██║██║     ╚════██║
██║ ╚═╝ ██║██║███████║╚██████╗    ██║     ╚██████╔╝██║ ╚████║╚██████╗███████║
╚═╝     ╚═╝╚═╝╚══════╝ ╚═════╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚══════╝
]]


--// Json To Table
function dxl.JsonToTable(json)
    assert(type(json) == "string", "[DXL Error] JsonToTable: First Argument needs to be a string!")

    return loadstring("return "..json:gsub('("[^"]-"):','[%1]='))()
end


--// Better Loadstring
function dxl.loadstring(string)
    assert(type(string) == "string", "[DXL Error] loadstring: First Argument needs to be a string!")

    if dxl.LoadstringCaching[string] == nil then
        dxl.LoadstringCaching[string] = dxl.OldLoadstring(string)
    else
        return dxl.LoadstringCaching[string]
    end
end
_G.loadstring = dxl.loadstring


--// Better Get
function dxl.Get(string)
    assert(type(string) == "string", "[DXL Error] Get: First Argument needs to be a string!")

    if dxl.GetCaching[string] == nil then
        dxl.GetCaching[string] = dxl.OldGet(string)
    else
        return dxl.GetCaching[string]
    end
end
_G.dx9.Get = dxl.Get


--// Better Console
function dxl.ShowConsole(useless_variable_used_to_hook_dx9_show_console_function_and_still_work_with_this_function)
    if not useless_variable_used_to_hook_dx9_show_console_function_and_still_work_with_this_function and useless_variable_used_to_hook_dx9_show_console_function_and_still_work_with_this_function ~= nil then return end

    if dxl.isMouseInArea({dxl.Location[1] + dxl.Size[1] - 27, dxl.Location[2] + 3, dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + 19}) then
        if dx9.isLeftClick() then
            dxl.Open = not dxl.Open;
        end

        dxl.Hovering = true
    else
        dxl.Hovering = false
    end

    --// Left Click Held
    if dx9.isLeftClickHeld() then
        --// Drag Func
        if dxl.Dragging or dxl.isMouseInArea({dxl.Location[1] - 5, dxl.Location[2] - 10, dxl.Location[1] + dxl.Size[1] + 5, dxl.Location[2] + 30}) then
            if not dxl.Dragging then dxl.Dragging = true end 

            if dxl.WinMouseOffset == nil then
                dxl.WinMouseOffset = {dx9.GetMouse().x - dxl.Location[1], dx9.GetMouse().y - dxl.Location[2]}
            end
            dxl.Location = {dx9.GetMouse().x - dxl.WinMouseOffset[1], dx9.GetMouse().y - dxl.WinMouseOffset[2]}
        end
    else
        dxl.Dragging = false
        dxl.WinMouseOffset = nil
    end

    if dxl.Open then
        dx9.DrawFilledBox({dxl.Location[1] - 1, dxl.Location[2] - 1}, {dxl.Location[1] + dxl.Size[1] + 1, dxl.Location[2] + dxl.Size[2] + 1}, dxl.Black) --// Outline
        dx9.DrawFilledBox(dxl.Location, {dxl.Location[1] + dxl.Size[1], dxl.Location[2] + dxl.Size[2]}, dxl.AccentColor) --// Accent
        dx9.DrawFilledBox({dxl.Location[1] + 1, dxl.Location[2] + 1}, {dxl.Location[1] + dxl.Size[1] - 1, dxl.Location[2] + dxl.Size[2] - 1}, dxl.MainColor) --// Main Outer (light gray)
        dx9.DrawFilledBox({dxl.Location[1] + 5, dxl.Location[2] + 20}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + dxl.Size[2] - 5}, dxl.BackgroundColor) --// Main Inner (dark gray)
        dx9.DrawBox({dxl.Location[1] + 5, dxl.Location[2] + 20}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + dxl.Size[2] - 5}, dxl.OutlineColor) --// Main Inner Outline 
        dx9.DrawBox({dxl.Location[1] + 6, dxl.Location[2] + 21}, {dxl.Location[1] + dxl.Size[1] - 6, dxl.Location[2] + dxl.Size[2] - 6}, dxl.Black) --// Main Inner Outline Black
        dx9.DrawString(dxl.Location, dxl.FontColor, "  DXLib Console | Mouse: "..Mouse.x..", "..Mouse.y) 

        for i,v in pairs(dxl.StoredLogs) do
            if string.sub(v, 1, 9) == "ERROR_TAG" then
                dx9.DrawString({dxl.Location[1] + 10, dxl.Location[2] + 5 + i*18}, dxl.ErrorColor, string.sub(v, 10, -1))
            else
                dx9.DrawString({dxl.Location[1] + 10, dxl.Location[2] + 5 + i*18}, dxl.FontColor, v)
            end
        end
    else
        dx9.DrawFilledBox({dxl.Location[1] + 300, dxl.Location[2] - 1}, {dxl.Location[1] + dxl.Size[1] + 1, dxl.Location[2] + 23}, dxl.Black) --// Outline
        dx9.DrawFilledBox({dxl.Location[1] + 301, dxl.Location[2]}, {dxl.Location[1] + dxl.Size[1],  dxl.Location[2] + 22}, dxl.AccentColor) --// Accent
        dx9.DrawFilledBox({dxl.Location[1] + 302, dxl.Location[2] + 1}, {dxl.Location[1] + dxl.Size[1] - 1,  dxl.Location[2] + 21}, dxl.MainColor) --// Main Outer (light gray)

        dx9.DrawString({dxl.Location[1] + 300, dxl.Location[2]}, dxl.FontColor, "  DXLib Console")
    end


    if dxl.Hovering then
        dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 27, dxl.Location[2] + 3}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + 19}, dxl.AccentColor) --// Outline
    else
        dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 27, dxl.Location[2] + 3}, {dxl.Location[1] + dxl.Size[1] - 5, dxl.Location[2] + 19}, dxl.Black) --// Outline
    end

    dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 26, dxl.Location[2] + 4}, {dxl.Location[1] + dxl.Size[1] - 6, dxl.Location[2] + 18}, dxl.OutlineColor) --// Inner Line
    dx9.DrawFilledBox({dxl.Location[1] + dxl.Size[1] - 25, dxl.Location[2] + 5}, {dxl.Location[1] + dxl.Size[1] - 7, dxl.Location[2] + 17}, dxl.MainColor) --// Inner

    dx9.DrawString({dxl.Location[1] + dxl.Size[1] - 20, dxl.Location[2] - 2}, dxl.FontColor, "_")

    function dxl.error(...)
        local temp = "";
        for i,v in pairs({...}) do
            temp = temp..tostring(v).." "
        end
        
        local split_string = {};
        if string.gmatch(temp, "([^\n]+)") ~= nil then
            for i in ( string.gmatch(temp, "([^\n]+)") ) do
                table.insert(split_string, i)
            end    
        end

        if split_string == {} then
            if #dxl.StoredLogs < 45 then
                table.insert(dxl.StoredLogs, "ERROR_TAG"..temp)
            else
                table.insert(dxl.StoredLogs, "ERROR_TAG"..temp)

                for i,v in pairs(dxl.StoredLogs) do
                    dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                end
            end
        else
            for i,v in pairs(split_string) do
                if #dxl.StoredLogs < 45 then
                    table.insert(dxl.StoredLogs, "ERROR_TAG"..v)
                else
                    table.insert(dxl.StoredLogs, "ERROR_TAG"..v)
        
                    for i,v in pairs(dxl.StoredLogs) do
                        dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                    end
                end
            end
        end
    end


    function print_table(node) -- https://stackoverflow.com/a/42062321/19113503
        local cache, stack, output = {},{},{}
        local depth = 1
        local output_str = "{\n"

        while true do
            local size = 0
            for k,v in pairs(node) do
                size = size + 1
            end

            local cur_index = 1
            for k,v in pairs(node) do
                if (cache[node] == nil) or (cur_index >= cache[node]) then

                    if (string.find(output_str,"}",output_str:len())) then
                        output_str = output_str .. ",\n"
                    elseif not (string.find(output_str,"\n",output_str:len())) then
                        output_str = output_str .. "\n"
                    end

                    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                    table.insert(output,output_str)
                    output_str = ""

                    local key
                    if (type(k) == "number" or type(k) == "boolean") then
                        key = "["..tostring(k).."]"
                    else
                        key = "['"..tostring(k).."']"
                    end

                    if (type(v) == "number" or type(v) == "boolean") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                    elseif (type(v) == "table") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                        table.insert(stack,node)
                        table.insert(stack,v)
                        cache[node] = cur_index+1
                        break
                    else
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                    end

                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    else
                        output_str = output_str .. ","
                    end
                else
                    -- close the table
                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    end
                end

                cur_index = cur_index + 1
            end

            if (size == 0) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            end

            if (#stack > 0) then
                node = stack[#stack]
                stack[#stack] = nil
                depth = cache[node] == nil and depth + 1 or depth - 1
            else
                break
            end
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output,output_str)
        output_str = table.concat(output)

        return output_str
    end


    function dxl.print(...)
        local temp = "";
        for i,v in pairs({...}) do
            if type(v) == "table" then
                temp = temp..print_table(v).." "
            else
                temp = temp..tostring(v).." "
            end
        end
        
        local split_string = {};
        if string.gmatch(temp, "([^\n]+)") ~= nil then
            for i in ( string.gmatch(temp, "([^\n]+)") ) do
                table.insert(split_string, i)
            end    
        end

        if split_string == {} then
            if #dxl.StoredLogs < 45 then
                table.insert(dxl.StoredLogs, temp)
            else
                table.insert(dxl.StoredLogs, temp)

                for i,v in pairs(dxl.StoredLogs) do
                    dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                end
            end
        else
            for i,v in pairs(split_string) do
                if #dxl.StoredLogs < 45 then
                    table.insert(dxl.StoredLogs, v)
                else
                    table.insert(dxl.StoredLogs, v)
        
                    for i,v in pairs(dxl.StoredLogs) do
                        dxl.StoredLogs[i] = dxl.StoredLogs[i + 1]
                    end
                end
            end
        end
    end

    dxl.StoredLogs = {};
    _G.dxl = dxl
end


--// Supg's attempt at making print() actually print as well as output to dxLib console (wish me luck)

function double_print(...)
    dxl.OldPrint(...);
    dxl.print(...);
end
_G.print = double_print
_G.error = dxl.error


--// Hooking DX9 Functions
if _G.betterdebugrun == nil then
    local havethesamestructionchild = {"FindFirstChild","FindFirstChildOfClass","FindFirstDescendant"}

    for i,v in pairs(havethesamestructionchild) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                dxl.error("[DX9 Error] "..v..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
            return
            end
            if type(args[2]) ~= "string" then
                dxl.error("[DX9 Error] "..v..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    local havethesamestruction = {"GetName","GetAllParts","GetCFrame","GetChildren","GetPosition","GetParent","GetTeam","GetTeamColour","GetCharacter","GetAdornee","GetType","GetImageLabelPosition","GetNumValue","GetStringValue","GetBoolValue"}
    local custommessages = {
        ["GetCharacter"] = ": First Argument needs to be a player instance!",
        ["GetTeam"] = ": First Argument needs to be a player instance!",
        ["GetTeamColour"] = ": First Argument needs to be a player instance!",
        ["GetNumValue"] = ": First Argument needs to be a IntValue Instance!",
    }
    for i,v in pairs(havethesamestruction) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "number" then
                local messagethign = custommessages[v] or ": First Argument needs to be a number (Instance)!"
                dxl.error("[DX9 Error] "..v..messagethign .. "\n" .. debug.traceback() .. "\n")
            return
            end
            return old(...)
        end
    end

    local old = _G["dx9"]["Teleport"]
    _G["dx9"]["Teleport"] = function(...)
        local args = {...}
        if type(args[1]) ~= "number" then
            dxl.error("[DX9 Error] ".."Teleport"..": First Argument needs to be a number! (Instance)" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] ".."Teleport"..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["SetAimbotValue"]
    _G["dx9"]["SetAimbotValue"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[DX9 Error] ".."SetAimbotValue"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "number" then
            dxl.error("[DX9 Error] ".."SetAimbotValue"..": Second Argument needs to be a Number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_info"]
    _G["dx9"]["get_info"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[DX9 Error] ".."get_info"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        if type(args[2]) ~= "string" then
            dxl.error("[DX9 Error] ".."get_info"..": Second Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["get_player"]
    _G["dx9"]["get_player"] = function(...)
        local args = {...}
        if type(args[1]) ~= "string" then
            dxl.error("[DX9 Error] ".."get_player"..": First Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
        return
        end
        return old(...)
    end

    for i,v in pairs({"FirstPersonAim","ThirdPersonAim"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "number" then
                dxl.error("[DX9 Error] "..v..": Second Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "number" then
                dxl.error("[DX9 Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            return old(...)
        end
    end

    for i,v in pairs({"DrawFilledBox","DrawLine","DrawBox"}) do
        local old = _G["dx9"][v]
        _G["dx9"][v] = function(...)
            local args = {...}
            if type(args[1]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[2]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end
            if type(args[3]) ~= "table" then
                dxl.error("[DX9 Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
                return
            end

            if args[1][1] + args[1][2] == 0 then return end
            if args[2][1] + args[2][2] == 0 then return end

            return old(...)
        end
    end

    local old = _G["dx9"]["DrawCircle"]
    _G["dx9"]["DrawCircle"] = function(...)
        local args = {...}
        local v = "DrawCircle"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "number" then
            dxl.error("[DX9 Error] "..v..": Third Argument needs to be a number!" .. "\n" .. debug.traceback() .. "\n")
            return
        end

        if args[1][1] + args[1][2] == 0 then return end

        return old(...)
    end

    local old = _G["dx9"]["DrawString"]
    _G["dx9"]["DrawString"] = function(...)
        local args = {...}
        local v = "DrawString"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "string" then
            dxl.error("[DX9 Error] "..v..": Third Argument needs to be a string!" .. "\n" .. debug.traceback() .. "\n")
            return
        end

        if args[1][1] + args[1][2] == 0 then return end

        return old(...)
    end

    local old = _G["dx9"]["Box3d"]
    _G["dx9"]["Box3d"] = function(...)
        local args = {...}
        local v = "Box3d"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[2]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Second Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[3]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Third Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[4]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Fourth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        if type(args[5]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": Fifth Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end

    local old = _G["dx9"]["WorldToScreen"]
    _G["dx9"]["WorldToScreen"] = function(...)
        local args = {...}
        local v = "WorldToScreen"
        if type(args[1]) ~= "table" then
            dxl.error("[DX9 Error] "..v..": First Argument needs to be a table!" .. "\n" .. debug.traceback() .. "\n")
            return
        end
        return old(...)
    end
    _G.betterdebugrun = {}
end
